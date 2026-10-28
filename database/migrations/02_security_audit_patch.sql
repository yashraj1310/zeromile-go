-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - 02_SECURITY_AUDIT_PATCH.SQL
-- Concurrency Triggers, Advisory Locks, Covering Indexes, Realtime Publications
-- ============================================================================

-- 1. HARDENED FUNCTIONS & TRIGGERS

-- Trigger 1: Concurrency-safe Max 3 Sub-Groups Limit
CREATE OR REPLACE FUNCTION public.check_subgroup_limit()
RETURNS TRIGGER 
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
    v_is_general BOOLEAN;
    v_count INT;
BEGIN
    SELECT is_general INTO v_is_general FROM public.sub_groups WHERE id = NEW.group_id;
    IF v_is_general IS FALSE THEN
        -- Advisory transaction lock prevents concurrent insertion race conditions for the same user & domain
        PERFORM pg_advisory_xact_lock(hashtext('subgroup_limit:' || NEW.domain_id::text || ':' || NEW.user_id::text));

        SELECT COUNT(*) INTO v_count
        FROM public.group_memberships gm
        JOIN public.sub_groups sg ON gm.group_id = sg.id
        WHERE gm.user_id = NEW.user_id
          AND gm.domain_id = NEW.domain_id
          AND sg.is_general = FALSE
          AND gm.id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid);
        
        IF v_count >= 3 THEN
            RAISE EXCEPTION 'User cannot join more than 3 sub-groups per event domain.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_check_subgroup_limit ON public.group_memberships;
CREATE TRIGGER trg_check_subgroup_limit
BEFORE INSERT OR UPDATE ON public.group_memberships
FOR EACH ROW
EXECUTE FUNCTION public.check_subgroup_limit();

-- Trigger 2: Auto-create Domain General Group
CREATE OR REPLACE FUNCTION public.auto_create_domain_general_group()
RETURNS TRIGGER 
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
    INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, approval_status)
    VALUES (NEW.id, 'General Group (' || NEW.name || ')', TRUE, 'GENERAL', 'APPROVED');
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_auto_create_general_group ON public.event_domains;
CREATE TRIGGER trg_auto_create_general_group
AFTER INSERT ON public.event_domains
FOR EACH ROW
EXECUTE FUNCTION public.auto_create_domain_general_group();

-- Trigger 3: Auto-enroll in General Group
CREATE OR REPLACE FUNCTION public.auto_enroll_general_group()
RETURNS TRIGGER 
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
    v_gen_group_id UUID;
    v_is_gen BOOLEAN;
BEGIN
    SELECT is_general INTO v_is_gen FROM public.sub_groups WHERE id = NEW.group_id;
    IF v_is_gen IS FALSE THEN
        SELECT id INTO v_gen_group_id
        FROM public.sub_groups
        WHERE domain_id = NEW.domain_id AND is_general = TRUE
        LIMIT 1;

        IF v_gen_group_id IS NOT NULL THEN
            INSERT INTO public.group_memberships (domain_id, group_id, user_id, is_active, is_leader, participation_status)
            VALUES (NEW.domain_id, v_gen_group_id, NEW.user_id, FALSE, FALSE, 'NOT_CHECKED_IN')
            ON CONFLICT (domain_id, group_id, user_id) DO NOTHING;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_auto_enroll_general_group ON public.group_memberships;
CREATE TRIGGER trg_auto_enroll_general_group
AFTER INSERT ON public.group_memberships
FOR EACH ROW
EXECUTE FUNCTION public.auto_enroll_general_group();

-- Trigger 4: Group Creation Request Approval
CREATE OR REPLACE FUNCTION public.process_group_creation_approval()
RETURNS TRIGGER 
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
    v_new_group_id UUID;
BEGIN
    IF (OLD.status IS DISTINCT FROM NEW.status) AND NEW.status = 'APPROVED' THEN
        SELECT id INTO v_new_group_id
        FROM public.sub_groups
        WHERE domain_id = NEW.domain_id AND name = NEW.org_name AND leader_id = NEW.applicant_user_id;

        IF v_new_group_id IS NULL THEN
            INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, leader_id, muster_point, approval_status)
            VALUES (NEW.domain_id, NEW.org_name, FALSE, NEW.org_type, NEW.applicant_user_id, NEW.muster_point, 'APPROVED')
            RETURNING id INTO v_new_group_id;
        END IF;

        UPDATE public.group_memberships
        SET is_active = FALSE
        WHERE domain_id = NEW.domain_id AND user_id = NEW.applicant_user_id;

        INSERT INTO public.group_memberships (domain_id, group_id, user_id, is_active, is_leader, participation_status)
        VALUES (NEW.domain_id, v_new_group_id, NEW.applicant_user_id, TRUE, TRUE, 'NOT_CHECKED_IN')
        ON CONFLICT (domain_id, group_id, user_id) 
        DO UPDATE SET is_active = TRUE, is_leader = TRUE;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_process_group_creation_approval ON public.group_creation_requests;
CREATE TRIGGER trg_process_group_creation_approval
AFTER UPDATE ON public.group_creation_requests
FOR EACH ROW
EXECUTE FUNCTION public.process_group_creation_approval();

-- 2. COVERING INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_broadcasts_domain_id ON public.broadcasts(domain_id);
CREATE INDEX IF NOT EXISTS idx_broadcasts_sender_id ON public.broadcasts(sender_id);
CREATE INDEX IF NOT EXISTS idx_broadcasts_target_group_id ON public.broadcasts(target_group_id);

CREATE INDEX IF NOT EXISTS idx_domain_superadmins_user_id ON public.domain_superadmins(user_id);
CREATE INDEX IF NOT EXISTS idx_group_creation_requests_applicant ON public.group_creation_requests(applicant_user_id);
CREATE INDEX IF NOT EXISTS idx_group_creation_requests_domain_id ON public.group_creation_requests(domain_id);
CREATE INDEX IF NOT EXISTS idx_group_memberships_group_id ON public.group_memberships(group_id);
CREATE INDEX IF NOT EXISTS idx_group_memberships_user_id ON public.group_memberships(user_id);
CREATE INDEX IF NOT EXISTS idx_group_memberships_domain_id ON public.group_memberships(domain_id);
CREATE INDEX IF NOT EXISTS idx_route_checkpoints_domain_id ON public.route_checkpoints(domain_id);
CREATE INDEX IF NOT EXISTS idx_sos_events_domain_id ON public.sos_events(domain_id);
CREATE INDEX IF NOT EXISTS idx_sos_events_sender_user_id ON public.sos_events(sender_user_id);
CREATE INDEX IF NOT EXISTS idx_sub_groups_domain_id ON public.sub_groups(domain_id);
CREATE INDEX IF NOT EXISTS idx_sub_groups_leader_id ON public.sub_groups(leader_id);
CREATE INDEX IF NOT EXISTS idx_user_live_locations_user_id ON public.user_live_locations(user_id);
CREATE INDEX IF NOT EXISTS idx_user_live_locations_active_group_id ON public.user_live_locations(active_group_id);
CREATE INDEX IF NOT EXISTS idx_user_live_locations_freshness ON public.user_live_locations(domain_id, updated_at DESC);

-- 3. REALTIME PUBLICATIONS
DO $$
BEGIN
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.sos_events;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.broadcasts;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.user_live_locations;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.group_memberships;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.group_creation_requests;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.sub_groups;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.event_domains;
    EXCEPTION WHEN duplicate_object THEN NULL;
    END;
END $$;
