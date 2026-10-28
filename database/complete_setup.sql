-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - 1-CLICK COMPLETE SETUP SCRIPT
-- Paste this entire script into your fresh Supabase SQL Editor and click "RUN"
-- ============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Clean slate if re-running
DROP TABLE IF EXISTS public.user_live_locations CASCADE;
DROP TABLE IF EXISTS public.sos_events CASCADE;
DROP TABLE IF EXISTS public.broadcasts CASCADE;
DROP TABLE IF EXISTS public.route_checkpoints CASCADE;
DROP TABLE IF EXISTS public.group_memberships CASCADE;
DROP TABLE IF EXISTS public.group_creation_requests CASCADE;
DROP TABLE IF EXISTS public.sub_groups CASCADE;
DROP TABLE IF EXISTS public.domain_superadmins CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS public.event_domains CASCADE;

-- 2. CORE TABLES (10 Relational Tables)

-- Table 1: event_domains
CREATE TABLE public.event_domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'CYCLING', 'MARATHON', 'PROTEST', 'WALKATHON'
    status VARCHAR(20) NOT NULL DEFAULT 'UPCOMING', -- 'UPCOMING', 'LIVE_ACTIVE', 'CONCLUDED', 'ARCHIVED'
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    route_geojson JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 2: users
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    emergency_contact VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 3: domain_superadmins
CREATE TABLE public.domain_superadmins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_by_dev VARCHAR(50) NOT NULL DEFAULT 'developer',
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_domain_superadmin UNIQUE (domain_id, user_id)
);

-- Table 4: sub_groups
CREATE TABLE public.sub_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    is_general BOOLEAN NOT NULL DEFAULT FALSE,
    org_type VARCHAR(60) NOT NULL, -- 'GENERAL', 'COLLEGE', 'NGO', 'LABOR_UNION', 'CORPORATE', 'SPORTS_CLUB', 'RWA', 'GRASSROOTS'
    leader_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    muster_point TEXT,
    approval_status VARCHAR(20) NOT NULL DEFAULT 'APPROVED', -- 'PENDING', 'APPROVED', 'REJECTED', 'SUSPENDED'
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 5: group_memberships
CREATE TABLE public.group_memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    group_id UUID NOT NULL REFERENCES public.sub_groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    is_leader BOOLEAN NOT NULL DEFAULT FALSE,
    participation_status VARCHAR(20) NOT NULL DEFAULT 'NOT_CHECKED_IN', -- 'NOT_CHECKED_IN', 'CHECKED_IN', 'IN_TRANSIT', 'COMPLETED', 'DROPPED_OUT'
    checkin_time TIMESTAMPTZ,
    completion_time TIMESTAMPTZ,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_group_membership UNIQUE (domain_id, group_id, user_id)
);

-- Partial Unique Index: Exactly 1 Active Group per User per Domain
CREATE UNIQUE INDEX unique_active_group_per_user_domain 
ON public.group_memberships (user_id, domain_id) 
WHERE is_active = TRUE;

-- Table 6: group_creation_requests
CREATE TABLE public.group_creation_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    applicant_user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    org_name VARCHAR(120) NOT NULL,
    org_type VARCHAR(60) NOT NULL,
    expected_count INT NOT NULL DEFAULT 20,
    muster_point TEXT NOT NULL,
    leader_notes TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    reviewed_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 7: broadcasts
CREATE TABLE public.broadcasts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    sender_role VARCHAR(20) NOT NULL, -- 'SUPERADMIN', 'GROUP_LEADER'
    target_type VARCHAR(20) NOT NULL, -- 'GENERAL', 'SPECIFIC_GROUP'
    target_group_id UUID REFERENCES public.sub_groups(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 8: sos_events
CREATE TABLE public.sos_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    sender_user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    active_sub_group_id UUID REFERENCES public.sub_groups(id) ON DELETE SET NULL,
    emergency_type VARCHAR(30) NOT NULL, -- 'MEDICAL', 'BREAKDOWN', 'THREAT', 'LOST', 'OTHER'
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'TRIGGERED', -- 'TRIGGERED', 'FORWARDED_TO_ADMIN', 'RESOLVED'
    forwarded_by_leader_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    leader_notes TEXT,
    resolved_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 9: user_live_locations
CREATE TABLE public.user_live_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    active_group_id UUID REFERENCES public.sub_groups(id) ON DELETE SET NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    speed_kmh REAL NOT NULL DEFAULT 0.0,
    heading REAL NOT NULL DEFAULT 0.0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_domain_live_location UNIQUE (domain_id, user_id)
);

-- Table 10: route_checkpoints
CREATE TABLE public.route_checkpoints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    checkpoint_type VARCHAR(30) NOT NULL, -- 'START', 'WATER_STATION', 'MEDICAL_POST', 'DIVERSION', 'FINISH'
    name VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    sequence_order INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. COVERING INDEXES
CREATE INDEX idx_broadcasts_domain_id ON public.broadcasts(domain_id);
CREATE INDEX idx_broadcasts_sender_id ON public.broadcasts(sender_id);
CREATE INDEX idx_domain_superadmins_user_id ON public.domain_superadmins(user_id);
CREATE INDEX idx_group_creation_requests_applicant ON public.group_creation_requests(applicant_user_id);
CREATE INDEX idx_group_memberships_group_id ON public.group_memberships(group_id);
CREATE INDEX idx_group_memberships_user_id ON public.group_memberships(user_id);
CREATE INDEX idx_route_checkpoints_domain_id ON public.route_checkpoints(domain_id);
CREATE INDEX idx_sos_events_domain_id ON public.sos_events(domain_id);
CREATE INDEX idx_sub_groups_domain_id ON public.sub_groups(domain_id);
CREATE INDEX idx_user_live_locations_user_id ON public.user_live_locations(user_id);
CREATE INDEX idx_user_live_locations_freshness ON public.user_live_locations(domain_id, updated_at DESC);

-- 4. CONCURRENCY TRIGGERS

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

-- 5. STORED PROCEDURES & RPCS (TEMPORALLY ENFORCED)

CREATE OR REPLACE FUNCTION public.set_active_group(
    p_domain_id UUID,
    p_group_id UUID,
    p_user_id UUID
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    UPDATE public.group_memberships
    SET is_active = FALSE
    WHERE domain_id = p_domain_id AND user_id = p_user_id;

    UPDATE public.group_memberships
    SET is_active = TRUE
    WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id;

    RETURN jsonb_build_object('success', true, 'active_group_id', p_group_id);
END;
$$;

CREATE OR REPLACE FUNCTION public.check_in_participant(
    p_domain_id UUID,
    p_group_id UUID,
    p_user_id UUID
) RETURNS JSONB 
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    UPDATE public.group_memberships
    SET participation_status = 'CHECKED_IN',
        checkin_time = NOW()
    WHERE domain_id = p_domain_id AND user_id = p_user_id AND group_id = p_group_id;

    RETURN jsonb_build_object('success', true, 'status', 'CHECKED_IN', 'checkin_time', NOW());
END;
$$;

CREATE OR REPLACE FUNCTION public.get_leader_squad_summary(
    p_domain_id UUID,
    p_group_id UUID
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
STABLE
AS $$
DECLARE
    v_total_enrolled INT := 0;
    v_checked_in INT := 0;
    v_completed INT := 0;
    v_active_telemetry INT := 0;
    v_pending_sos INT := 0;
    v_group_name TEXT := '';
    v_muster_point TEXT := '';
BEGIN
    SELECT name, muster_point INTO v_group_name, v_muster_point
    FROM public.sub_groups
    WHERE id = p_group_id AND domain_id = p_domain_id;

    SELECT 
        COUNT(*),
        COUNT(*) FILTER (WHERE participation_status = 'CHECKED_IN'),
        COUNT(*) FILTER (WHERE participation_status = 'COMPLETED')
    INTO v_total_enrolled, v_checked_in, v_completed
    FROM public.group_memberships
    WHERE domain_id = p_domain_id AND group_id = p_group_id;

    SELECT COUNT(*)
    INTO v_active_telemetry
    FROM public.user_live_locations
    WHERE domain_id = p_domain_id 
      AND active_group_id = p_group_id 
      AND updated_at > (NOW() - INTERVAL '15 minutes');

    SELECT COUNT(*)
    INTO v_pending_sos
    FROM public.sos_events
    WHERE domain_id = p_domain_id 
      AND active_sub_group_id = p_group_id 
      AND status != 'RESOLVED';

    RETURN jsonb_build_object(
        'group_id', p_group_id,
        'group_name', COALESCE(v_group_name, 'Unknown Squad'),
        'muster_point', COALESCE(v_muster_point, 'General Assembly'),
        'total_enrolled', v_total_enrolled,
        'checked_in', v_checked_in,
        'completed', v_completed,
        'active_telemetry', v_active_telemetry,
        'pending_sos', v_pending_sos,
        'checkin_percentage', CASE WHEN v_total_enrolled > 0 THEN ROUND((v_checked_in::NUMERIC / v_total_enrolled::NUMERIC) * 100, 1) ELSE 0.0 END,
        'completion_percentage', CASE WHEN v_total_enrolled > 0 THEN ROUND((v_completed::NUMERIC / v_total_enrolled::NUMERIC) * 100, 1) ELSE 0.0 END
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_sector_density_metrics(
    p_domain_id UUID
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
STABLE
AS $$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_agg(
        jsonb_build_object(
            'checkpoint_id', cp.id,
            'sequence_order', cp.sequence_order,
            'name', cp.name,
            'checkpoint_type', cp.checkpoint_type,
            'latitude', cp.latitude,
            'longitude', cp.longitude,
            'active_riders_nearby', (
                SELECT COUNT(*)
                FROM public.user_live_locations loc
                WHERE loc.domain_id = p_domain_id
                  AND loc.updated_at > (NOW() - INTERVAL '15 minutes')
                  AND loc.latitude BETWEEN (cp.latitude - 0.005) AND (cp.latitude + 0.005)
                  AND loc.longitude BETWEEN (cp.longitude - 0.005) AND (cp.longitude + 0.005)
            )
        ) ORDER BY cp.sequence_order ASC
    ) INTO v_result
    FROM public.route_checkpoints cp
    WHERE cp.domain_id = p_domain_id;

    RETURN COALESCE(v_result, '[]'::jsonb);
END;
$$;

CREATE OR REPLACE FUNCTION public.get_event_telemetry_summary(
    p_domain_id UUID
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_total_checkpoints INT;
    v_active_gps INT;
    v_pending_sos INT;
    v_recent_broadcasts INT;
BEGIN
    SELECT COUNT(*) INTO v_total_checkpoints FROM public.route_checkpoints WHERE domain_id = p_domain_id;
    SELECT COUNT(*) INTO v_active_gps FROM public.user_live_locations WHERE domain_id = p_domain_id AND updated_at >= NOW() - INTERVAL '15 minutes';
    SELECT COUNT(*) INTO v_pending_sos FROM public.sos_events WHERE domain_id = p_domain_id AND status = 'TRIGGERED';
    SELECT COUNT(*) INTO v_recent_broadcasts FROM public.broadcasts WHERE domain_id = p_domain_id;

    RETURN jsonb_build_object(
        'total_checkpoints', v_total_checkpoints,
        'active_gps_feeds', v_active_gps,
        'pending_sos_count', v_pending_sos,
        'total_broadcasts', v_recent_broadcasts
    );
END;
$$;

-- 6. ROW LEVEL SECURITY (RLS) POLICIES
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

CREATE POLICY "Public read event_domains" ON public.event_domains FOR SELECT USING (true);
CREATE POLICY "Public read sub_groups" ON public.sub_groups FOR SELECT USING (true);
CREATE POLICY "Public read route_checkpoints" ON public.route_checkpoints FOR SELECT USING (true);
CREATE POLICY "Public read broadcasts" ON public.broadcasts FOR SELECT USING (true);
CREATE POLICY "Public read user_live_locations" ON public.user_live_locations FOR SELECT USING (true);
CREATE POLICY "Public read sos_events" ON public.sos_events FOR SELECT USING (true);
CREATE POLICY "Public read group_memberships" ON public.group_memberships FOR SELECT USING (true);
CREATE POLICY "Public read users" ON public.users FOR SELECT USING (true);
CREATE POLICY "Public read domain_superadmins" ON public.domain_superadmins FOR SELECT USING (true);

-- Mutations allowed via standard client roles
CREATE POLICY "App write user_live_locations" ON public.user_live_locations FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "App write sos_events" ON public.sos_events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "App write broadcasts" ON public.broadcasts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "App write group_creation_requests" ON public.group_creation_requests FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "App write group_memberships" ON public.group_memberships FOR ALL USING (true) WITH CHECK (true);

-- 7. REALTIME WEBSOCKET PUBLICATIONS
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

-- 8. CANONICAL SEED DATA (Fixed Deterministic UUIDs matching Frontend)
DO $$
DECLARE
    v_cycling_id UUID := 'a1111111-1111-1111-1111-111111111111'::uuid;
    v_marathon_id UUID := 'b2222222-2222-2222-2222-222222222222'::uuid;
    v_walkathon_id UUID := 'c3333333-3333-3333-3333-333333333333'::uuid;

    v_admin1_id UUID;
    v_admin2_id UUID;
    v_leader_vnit_id UUID;
    v_leader_orange_id UUID;
    v_group_vnit_id UUID;
    v_group_orange_id UUID;
BEGIN
    -- Event Domains
    INSERT INTO public.event_domains (id, name, slug, type, status, start_time, end_time, route_geojson)
    VALUES (
        v_cycling_id,
        'Cycling Rally 2026',
        'cycling-2026',
        'CYCLING',
        'LIVE_ACTIVE',
        NOW() - INTERVAL '1 hour',
        NOW() + INTERVAL '4 hours',
        '{
            "type": "FeatureCollection",
            "features": [
                {
                    "type": "Feature",
                    "geometry": {
                        "type": "LineString",
                        "coordinates": [
                            [79.0806, 21.1498],
                            [79.0882, 21.1465],
                            [79.0682, 21.1378],
                            [79.0550, 21.1420],
                            [79.0664, 21.1278]
                        ]
                    },
                    "properties": { "name": "Official 24km Nagpur Loop" }
                }
            ]
        }'::jsonb
    ) ON CONFLICT (id) DO UPDATE SET status = 'LIVE_ACTIVE', start_time = NOW() - INTERVAL '1 hour', end_time = NOW() + INTERVAL '4 hours';

    INSERT INTO public.event_domains (id, name, slug, type, status, start_time, end_time)
    VALUES (
        v_marathon_id,
        'Nagpur City Marathon 2026',
        'marathon-2026',
        'MARATHON',
        'UPCOMING',
        NOW() + INTERVAL '7 days',
        NOW() + INTERVAL '7 days 5 hours'
    ) ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.event_domains (id, name, slug, type, status, start_time, end_time)
    VALUES (
        v_walkathon_id,
        'Citizen Environmental Walkathon',
        'walkathon-2026',
        'WALKATHON',
        'CONCLUDED',
        NOW() - INTERVAL '3 days',
        NOW() - INTERVAL '3 days' + INTERVAL '3 hours'
    ) ON CONFLICT (id) DO NOTHING;

    -- SuperAdmins
    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822011111', 'Civic Operations SuperAdmin 1', '+91 98220 99991')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_admin1_id;

    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9823012345', 'Civic Operations SuperAdmin 2', '+91 98230 99992')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_admin2_id;

    INSERT INTO public.domain_superadmins (domain_id, user_id, created_by_dev)
    VALUES 
        (v_cycling_id, v_admin1_id, 'system_seed'),
        (v_cycling_id, v_admin2_id, 'system_seed'),
        (v_marathon_id, v_admin2_id, 'system_seed')
    ON CONFLICT (domain_id, user_id) DO NOTHING;

    -- Group Leaders
    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822055555', 'Prof. Arvind Rao (VNIT Leader)', '+91 98220 99995')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_leader_vnit_id;

    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822066666', 'Manoj Tiwari (Orange City Riders)', '+91 98220 99996')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_leader_orange_id;

    -- Sub-Groups
    INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, leader_id, muster_point, approval_status)
    VALUES (v_cycling_id, 'VNIT Cyclists Contingent', FALSE, 'COLLEGE', v_leader_vnit_id, 'VNIT Main Gate, South Ambazari Rd', 'APPROVED')
    RETURNING id INTO v_group_vnit_id;

    INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, leader_id, muster_point, approval_status)
    VALUES (v_cycling_id, 'Orange City Riders Club', FALSE, 'SPORTS_CLUB', v_leader_orange_id, 'Zero Mile Freedom Park Monument', 'APPROVED')
    RETURNING id INTO v_group_orange_id;

    -- Checkpoints
    INSERT INTO public.route_checkpoints (domain_id, checkpoint_type, name, latitude, longitude, sequence_order)
    VALUES
        (v_cycling_id, 'START', 'Zero Mile Flag-Off Arch', 21.1458, 79.0882, 1),
        (v_cycling_id, 'WATER_STATION', 'Shankar Nagar Square Hydration Post', 21.1310, 79.0600, 2),
        (v_cycling_id, 'MEDICAL_POST', 'Law College Square Trauma Van', 21.1390, 79.0680, 3),
        (v_cycling_id, 'WATER_STATION', 'Civil Lines Japanese Garden Station', 21.1620, 79.0620, 4),
        (v_cycling_id, 'FINISH', 'Sitabuldi Interchange Finish Line', 21.1460, 79.0820, 5)
    ON CONFLICT DO NOTHING;

    -- Broadcast
    INSERT INTO public.broadcasts (domain_id, sender_id, sender_role, target_type, message_text)
    VALUES (
        v_cycling_id,
        v_admin2_id,
        'SUPERADMIN',
        'GENERAL',
        'Official Notice: Cycling Rally starts at 06:00 AM sharp from Zero Mile Monument. Helmets mandatory.'
    );
END $$;
