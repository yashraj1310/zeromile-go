-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - SEED.SQL
-- Canonical Seed Data with Deterministic UUIDs for Seamless Cross-Platform Sync
-- ============================================================================

DO $$
DECLARE
    -- Fixed Deterministic Domain UUIDs matching web_platform and mobile
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
    -- 1. Insert Event Domains with Deterministic UUIDs
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

    -- 2. Insert SuperAdmin Users
    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822011111', 'Civic Operations SuperAdmin 1', '+91 98220 99991')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_admin1_id;

    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9823012345', 'Civic Operations SuperAdmin 2', '+91 98230 99992')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_admin2_id;

    -- 3. Assign SuperAdmins to Domains
    INSERT INTO public.domain_superadmins (domain_id, user_id, created_by_dev)
    VALUES 
        (v_cycling_id, v_admin1_id, 'system_seed'),
        (v_cycling_id, v_admin2_id, 'system_seed'),
        (v_marathon_id, v_admin2_id, 'system_seed')
    ON CONFLICT (domain_id, user_id) DO NOTHING;

    -- 4. Insert Group Leaders
    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822055555', 'VNIT Contingent Lead', '+91 98220 99995')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_leader_vnit_id;

    INSERT INTO public.users (phone_number, full_name, emergency_contact)
    VALUES ('9822066666', 'Orange City Riders Lead', '+91 98220 99996')
    ON CONFLICT (phone_number) DO UPDATE SET full_name = EXCLUDED.full_name
    RETURNING id INTO v_leader_orange_id;

    -- 5. Insert Sub-Groups
    INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, leader_id, muster_point, approval_status)
    VALUES (v_cycling_id, 'VNIT Cyclists Contingent', FALSE, 'COLLEGE', v_leader_vnit_id, 'VNIT Main Gate, South Ambazari Rd', 'APPROVED')
    RETURNING id INTO v_group_vnit_id;

    INSERT INTO public.sub_groups (domain_id, name, is_general, org_type, leader_id, muster_point, approval_status)
    VALUES (v_cycling_id, 'Orange City Riders Club', FALSE, 'SPORTS_CLUB', v_leader_orange_id, 'Zero Mile Freedom Park Monument', 'APPROVED')
    RETURNING id INTO v_group_orange_id;

    -- 6. Insert Route Checkpoints for Cycling Domain
    INSERT INTO public.route_checkpoints (domain_id, checkpoint_type, name, latitude, longitude, sequence_order)
    VALUES
        (v_cycling_id, 'START', 'Zero Mile Flag-Off Arch', 21.1458, 79.0882, 1),
        (v_cycling_id, 'WATER_STATION', 'Shankar Nagar Square Hydration Post', 21.1310, 79.0600, 2),
        (v_cycling_id, 'MEDICAL_POST', 'Law College Square Trauma Van', 21.1390, 79.0680, 3),
        (v_cycling_id, 'WATER_STATION', 'Civil Lines Japanese Garden Station', 21.1620, 79.0620, 4),
        (v_cycling_id, 'FINISH', 'Sitabuldi Interchange Finish Line', 21.1460, 79.0820, 5);

    -- 7. Insert Initial Broadcast
    INSERT INTO public.broadcasts (domain_id, sender_id, sender_role, target_type, message_text)
    VALUES (
        v_cycling_id,
        v_admin2_id,
        'SUPERADMIN',
        'GENERAL',
        'Official Notice: Cycling Rally starts at 06:00 AM sharp from Zero Mile Monument. Helmets mandatory.'
    );
END $$;
