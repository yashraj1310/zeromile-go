-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - 04_UX_PERFORMANCE_RPCS.SQL
-- Dynamic Crowd Density Metrics, Squad Summaries & Event Telemetry RPCs
-- ============================================================================

-- 1. Leader Squad Summary RPC (1 roundtrip for Leader HUD Header)
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

-- 2. Sector Density Aggregation RPC (for Live Map Color Shading)
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

-- 3. Telemetry Summary RPC (for SuperAdmin Console Analytics)
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
