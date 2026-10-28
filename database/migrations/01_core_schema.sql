-- ============================================================================
-- VIKASIT NAGPUR / ZEROMILE GO - 01_CORE_SCHEMA.SQL
-- 10-Table Core Architecture, Constraints, Triggers & Initial Stored Procedures
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Table 1: event_domains
CREATE TABLE IF NOT EXISTS public.event_domains (
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
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    emergency_contact VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table 3: domain_superadmins
CREATE TABLE IF NOT EXISTS public.domain_superadmins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_by_dev VARCHAR(50) NOT NULL DEFAULT 'developer',
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_domain_superadmin UNIQUE (domain_id, user_id)
);

-- Table 4: sub_groups
CREATE TABLE IF NOT EXISTS public.sub_groups (
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
CREATE TABLE IF NOT EXISTS public.group_memberships (
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
CREATE UNIQUE INDEX IF NOT EXISTS unique_active_group_per_user_domain 
ON public.group_memberships (user_id, domain_id) 
WHERE is_active = TRUE;

-- Table 6: group_creation_requests
CREATE TABLE IF NOT EXISTS public.group_creation_requests (
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
CREATE TABLE IF NOT EXISTS public.broadcasts (
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
CREATE TABLE IF NOT EXISTS public.sos_events (
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
CREATE TABLE IF NOT EXISTS public.user_live_locations (
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
CREATE TABLE IF NOT EXISTS public.route_checkpoints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES public.event_domains(id) ON DELETE CASCADE,
    checkpoint_type VARCHAR(30) NOT NULL, -- 'START', 'WATER_STATION', 'MEDICAL_POST', 'DIVERSION', 'FINISH'
    name VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    sequence_order INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
