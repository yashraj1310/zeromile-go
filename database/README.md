# Vikasit Nagpur / ZeroMile Go — Database Architecture & Migrations

This directory contains the canonical PostgreSQL 15 / Supabase database migrations for the Vikasit Nagpur multi-tenant event management platform.

## Migration Sequence

Apply migrations in ascending numerical order:

1. `migrations/01_core_schema.sql`: 10 core tables (`event_domains`, `users`, `domain_superadmins`, `sub_groups`, `group_memberships`, `group_creation_requests`, `broadcasts`, `sos_events`, `user_live_locations`, `route_checkpoints`), unique constraints, and foreign keys.
2. `migrations/02_security_audit_patch.sql`: Concurrency-safe sub-group limit trigger with advisory transaction lock (`pg_advisory_xact_lock`), auto-create domain general group, auto-enrollment, covering indexes, and Realtime publications.
3. `migrations/03_production_hardening.sql`: Server-side temporal window validation on RPCs (`start_time` <= now <= `end_time`), SuperAdmin 6-seat cap enforcement, and hardened Row Level Security (RLS) policies.
4. `migrations/04_ux_performance_rpcs.sql`: High-performance aggregation RPCs (`get_leader_squad_summary`, `get_sector_density_metrics`, `get_event_telemetry_summary`).
5. `seed.sql`: Canonical seed data for Nagpur Cycling 2026, Marathon 2026, Walkathon 2026, route checkpoints, SuperAdmins, and Group Leaders.

## Execution via Supabase CLI

```bash
supabase db push
# or to reset and seed
supabase db reset
```

## Rollback Strategy

Each migration is safe to re-run with `IF NOT EXISTS` and `CREATE OR REPLACE FUNCTION`. To drop and recreate:
```sql
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
```
