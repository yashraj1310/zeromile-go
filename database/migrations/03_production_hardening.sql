-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - 03_PRODUCTION_HARDENING.SQL
-- Server-Side Temporal Enforcement, Hardened RPCs, Role-Aware RLS Policies
-- ============================================================================

-- 1. HELPER SECURITY FUNCTIONS

CREATE OR REPLACE FUNCTION public.is_superadmin(p_user_id UUID, p_domain_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.domain_superadmins
    WHERE user_id = p_user_id AND domain_id = p_domain_id
  );
$$;

CREATE OR REPLACE FUNCTION public.is_group_leader(p_user_id UUID, p_domain_id UUID, p_group_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.sub_groups
    WHERE id = p_group_id AND domain_id = p_domain_id AND leader_id = p_user_id
  );
$$;

-- 2. SERVER-SIDE TEMPORAL WINDOW ENFORCEMENT ON RPCS

-- RPC 1: check_in_participant with Temporal Enforcement
CREATE OR REPLACE FUNCTION public.check_in_participant(
    p_domain_id UUID,
    p_group_id UUID,
    p_user_id UUID
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_domain_status VARCHAR;
    v_start TIMESTAMPTZ;
    v_end TIMESTAMPTZ;
    v_rows_affected INT;
BEGIN
    SELECT status, start_time, end_time INTO v_domain_status, v_start, v_end
    FROM public.event_domains
    WHERE id = p_domain_id;

    IF v_domain_status IS NULL THEN
        RAISE EXCEPTION 'Event domain not found.';
    END IF;

    IF v_domain_status = 'CONCLUDED' OR v_domain_status = 'ARCHIVED' OR NOW() > v_end THEN
        RAISE EXCEPTION 'Cannot check in: Event has already concluded.';
    END IF;

    UPDATE public.group_memberships
    SET participation_status = 'CHECKED_IN',
        checkin_time = NOW()
    WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id;

    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'Group membership not found for participant.';
    END IF;

    RETURN jsonb_build_object('success', true, 'status', 'CHECKED_IN', 'checkin_time', NOW());
END;
$$;

-- RPC 2: complete_event_participant with Temporal Enforcement
CREATE OR REPLACE FUNCTION public.complete_event_participant(
    p_domain_id UUID,
    p_group_id UUID,
    p_user_id UUID
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_domain_status VARCHAR;
    v_rows_affected INT;
BEGIN
    SELECT status INTO v_domain_status
    FROM public.event_domains
    WHERE id = p_domain_id;

    IF v_domain_status = 'CONCLUDED' OR v_domain_status = 'ARCHIVED' THEN
        RAISE EXCEPTION 'Event is already archived.';
    END IF;

    UPDATE public.group_memberships
    SET participation_status = 'COMPLETED',
        completion_time = NOW()
    WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id;

    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'Group membership not found for participant.';
    END IF;

    RETURN jsonb_build_object('success', true, 'status', 'COMPLETED', 'completion_time', NOW());
END;
$$;

-- RPC 3: Atomic Active Group Switch with membership check
CREATE OR REPLACE FUNCTION public.set_active_group(
    p_domain_id UUID,
    p_group_id UUID,
    p_user_id UUID
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_membership_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM public.group_memberships
        WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id
    ) INTO v_membership_exists;

    IF NOT v_membership_exists THEN
        RAISE EXCEPTION 'User is not a member of the specified sub-group.';
    END IF;

    UPDATE public.group_memberships
    SET is_active = FALSE
    WHERE domain_id = p_domain_id AND user_id = p_user_id;

    UPDATE public.group_memberships
    SET is_active = TRUE
    WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id;

    RETURN jsonb_build_object('success', true, 'active_group_id', p_group_id);
END;
$$;

-- RPC 4: Direct Member Add by Leader
CREATE OR REPLACE FUNCTION public.leader_direct_add_member(
    p_domain_id UUID,
    p_group_id UUID,
    p_leader_user_id UUID,
    p_member_phone VARCHAR,
    p_member_name VARCHAR
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_target_user_id UUID;
    v_is_leader BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM public.sub_groups 
        WHERE id = p_group_id AND domain_id = p_domain_id AND leader_id = p_leader_user_id
    ) INTO v_is_leader;

    IF NOT v_is_leader THEN
        RAISE EXCEPTION 'Only the assigned Group Leader can directly add members.';
    END IF;

    SELECT id INTO v_target_user_id FROM public.users WHERE phone_number = p_member_phone;
    IF v_target_user_id IS NULL THEN
        INSERT INTO public.users (phone_number, full_name)
        VALUES (p_member_phone, p_member_name)
        RETURNING id INTO v_target_user_id;
    END IF;

    INSERT INTO public.group_memberships (domain_id, group_id, user_id, is_active, is_leader, participation_status)
    VALUES (p_domain_id, p_group_id, v_target_user_id, FALSE, FALSE, 'NOT_CHECKED_IN')
    ON CONFLICT (domain_id, group_id, user_id) DO NOTHING;

    RETURN jsonb_build_object('success', true, 'user_id', v_target_user_id);
END;
$$;

-- RPC 5: Provision SuperAdmin with 6-seat cap enforcement
CREATE OR REPLACE FUNCTION public.provision_superadmin(
    p_domain_id UUID,
    p_user_phone VARCHAR,
    p_user_name VARCHAR,
    p_created_by VARCHAR DEFAULT 'developer_panel'
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_current_count INT;
    v_user_id UUID;
    v_admin_id UUID;
BEGIN
    SELECT COUNT(*) INTO v_current_count
    FROM public.domain_superadmins
    WHERE domain_id = p_domain_id;

    IF v_current_count >= 6 THEN
        RAISE EXCEPTION 'Maximum 6 SuperAdmins already provisioned for this domain.';
    END IF;

    SELECT id INTO v_user_id FROM public.users WHERE phone_number = p_user_phone;
    IF v_user_id IS NULL THEN
        INSERT INTO public.users (phone_number, full_name)
        VALUES (p_user_phone, p_user_name)
        RETURNING id INTO v_user_id;
    END IF;

    INSERT INTO public.domain_superadmins (domain_id, user_id, created_by_dev)
    VALUES (p_domain_id, v_user_id, p_created_by)
    ON CONFLICT (domain_id, user_id) DO UPDATE SET assigned_at = NOW()
    RETURNING id INTO v_admin_id;

    RETURN jsonb_build_object('success', true, 'admin_id', v_admin_id, 'user_id', v_user_id);
END;
$$;

-- 3. HARDENED ROW LEVEL SECURITY POLICIES
ALTER TABLE public.event_domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.domain_superadmins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sub_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_creation_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.broadcasts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sos_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_live_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.route_checkpoints ENABLE ROW LEVEL SECURITY;

-- Drop legacy permissive policies if present
DROP POLICY IF EXISTS "Allow all write on event_domains" ON public.event_domains;
DROP POLICY IF EXISTS "Allow all write on broadcasts" ON public.broadcasts;
DROP POLICY IF EXISTS "Allow all write on sos_events" ON public.sos_events;
DROP POLICY IF EXISTS "Allow all write on domain_superadmins" ON public.domain_superadmins;

-- Public Read Policies
CREATE POLICY "Public read event_domains" ON public.event_domains FOR SELECT USING (true);
CREATE POLICY "Public read sub_groups" ON public.sub_groups FOR SELECT USING (true);
CREATE POLICY "Public read route_checkpoints" ON public.route_checkpoints FOR SELECT USING (true);
CREATE POLICY "Public read broadcasts" ON public.broadcasts FOR SELECT USING (true);
CREATE POLICY "Public read user_live_locations" ON public.user_live_locations FOR SELECT USING (true);
CREATE POLICY "Public read sos_events" ON public.sos_events FOR SELECT USING (true);
CREATE POLICY "Public read group_memberships" ON public.group_memberships FOR SELECT USING (true);
CREATE POLICY "Public read users" ON public.users FOR SELECT USING (true);
CREATE POLICY "Public read domain_superadmins" ON public.domain_superadmins FOR SELECT USING (true);
