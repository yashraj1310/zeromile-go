# VIKASIT NAGPUR / ZEROMILE GO — SYSTEM ARCHITECTURE SPECIFICATION

## 1. Architectural Philosophy
ZeroMile Go is an intelligent urban mobility and civic event orchestration platform engineered for Nagpur's Smart City infrastructure. The codebase follows a clean, modular **Layered Monorepo Architecture** with strict separation of concerns across presentation, business logic, geospatial processing, and persistence.

---

## 2. System Overview & Clean Directory Layout

```text
Vikasit Nagpur / ZeroMile Go Root
├── apps/                                       # RUNNABLE APPLICATIONS
│   ├── web/                                    # Command Studio & Commuter Web Platform
│   │   ├── src/
│   │   │   ├── components/landing/             # Public landing page, hero search, civic chips
│   │   │   ├── features/
│   │   │   │   ├── admin/                      # Operational command center, telemetry, SOS feed
│   │   │   │   ├── auth/                       # SuperAdmin & commuter gateway authentication
│   │   │   │   ├── checkpoints/                # 6 checkpoint types management
│   │   │   │   ├── emergency/                  # Civic alert broadcast & SOS escalation modals
│   │   │   │   ├── map/                        # Mapbox GL JS 3D, 4 lighting modes, orbit controls
│   │   │   │   ├── routes/                     # Corridor studio, polyline dragging, police roadblocks
│   │   │   │   └── transit/                    # Commuter route planning, conflict detection, HUD
│   │   │   ├── services/                       # Nagpur places registry, Mapbox directions, Supabase
│   │   │   ├── types/                          # UI types & domain re-exports
│   │   │   └── config/                         # Dual-prefix environment resolution
│   │   ├── tests/                              # Automated integration & contract test suite
│   │   ├── index.html                          # Modern Vite entry point
│   │   ├── vite.config.ts                      # Multi-prefix env loader & manual chunk splitting
│   │   └── package.json                        # Scripts: dev, build, typecheck, preview
│   └── mobile/                                 # Cross-Platform Mobile Application (Flutter 3 / Dart)
│       ├── lib/
│       │   ├── core/                           # API service, mock data service, shared models
│       │   └── features/                       # Admin, leader, participant, police, profile screens
│       └── pubspec.yaml                        # Dependencies and assets manifest
│
├── database/                                   # DATA PERSISTENCE & SCHEMAS
│   ├── migrations/                             # Versioned PostgreSQL DDL migrations
│   │   ├── 01_core_schema.sql                  # Users, event_domains, checkpoints, telemetry
│   │   ├── 02_security_audit.sql               # Security audit triggers & integrity functions
│   │   ├── 03_production_hardening.sql         # Row Level Security (RLS) & access policies
│   │   └── 04_ux_enhancements_rpcs.sql        # High-performance stored procedures
│   ├── seed.sql                                # Deterministic UUID seeds & canonical SuperAdmins
│   └── complete_setup.sql                      # Single consolidated setup script
│
├── shared/                                     # CROSS-PLATFORM CONTRACTS
│   └── types/domain_contracts.ts               # Shared TypeScript schemas for Web and Mobile
│
├── docs/                                       # DOCUMENTATION & SPECIFICATIONS
│   ├── ARCHITECTURE.md                         # This architecture specification
│   ├── SYSTEM_FLOW.md                          # Interactive state machine & role flow diagrams
│   └── PROJECT_PLAN.md                         # Detailed project roadmap and milestones
│
└── archive/                                    # PRESERVED HISTORICAL ASSETS (Non-Active)
    ├── legacy_archive/                         # Historical vanilla JS platform & prototypes
    ├── web-public/                             # Historical August web simulator
    ├── ZeroMile-main/                          # Historical native Android Kotlin application
    └── _RECOVERY_BACKUP_ORIGINAL_SOURCE_...zip # Verified safety backup archive
```

---

## 3. Layered Architectural Model

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                              │
│                                                                        │
│   Web Command Studio (React 18 + TS)      Mobile App (Flutter / Dart)  │
│   • Persistent Mapbox 3D WebGL Canvas     • GPS Background Telemetry   │
│   • Corridor Studio & Police Barricades   • SOS Panic Trigger          │
│   • Commuter Routing & Conflict HUD       • Leader Sub-Group Dashboard │
└───────────────────▲──────────────────────────────────▲─────────────────┘
                    │                                  │
┌───────────────────┴──────────────────────────────────┴─────────────────┐
│                      SHARED CONTRACTS LAYER                            │
│                                                                        │
│   shared/types/domain_contracts.ts                                     │
│   • Deterministic Event Domain UUIDs (Cycling, Marathon, Visarjan)    │
│   • Telemetry Payload & Speed Protocol (Lat, Lng, Speed, Battery)      │
│   • Checkpoint Models (Water, Medical, Timing, Cheer, Start, Finish)   │
│   • Civic Broadcast & SOS Incident Data Contracts                      │
└───────────────────▲──────────────────────────────────▲─────────────────┘
                    │                                  │
┌───────────────────┴──────────────────────────────────┴─────────────────┐
│                    API & BUSINESS LOGIC LAYER                          │
│                                                                        │
│   • Mapbox Directions API v5 (Corridor & Detour Generation)            │
│   • Nagpur Registry Service (Canonical Geofenced Landmarks)           │
│   • Supabase Auth Service (Phone + OTP + Relational Admin Join)        │
│   • PostgREST Gateway & Realtime WebSocket Channels                    │
└───────────────────▲──────────────────────────────────▲─────────────────┘
                    │                                  │
┌───────────────────┴──────────────────────────────────┴─────────────────┐
│                    PERSISTENCE & SECURITY LAYER                        │
│                                                                        │
│   Supabase PostgreSQL 15                                               │
│   • Row-Level Security (RLS) enforcement per role                      │
│   • Security-Definer RPC: is_superadmin(user_id, domain_id)            │
│   • Realtime Publication Tables: telemetry, broadcasts, sos_events     │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Key Architectural Decisions

1. **Persistent Mapbox WebGL Context**:
   * The Mapbox GL JS map canvas is mounted persistently at `zIndex: 0`.
   * UI panels (Landing Page, Commuter Panel, Route Studio, Command Center) mount as transparent or floating glass overlays (`zIndex: 10` to `zIndex: 50`).
   * This eliminates WebGL context loss, canvas re-instantiation stutter, and ensures instant camera transitions between view modes.

2. **Decoupled Monorepo Structure**:
   * `apps/web` and `apps/mobile` are completely decoupled, sharing only data contracts via `shared/`.
   * Developers can run, test, build, and deploy the web platform or the Flutter mobile application independently.

3. **Isolated Archive Storage**:
   * All historical prototypes (`web-public`, `ZeroMile-main`, `legacy_archive`) and recovery zip files reside exclusively inside `archive/`.
   * This eliminates root clutter, prevents accidental imports of dead code, and provides clear visibility for onboarding engineers.
