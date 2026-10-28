# 🧭 ZeroMile Go — Smart Urban Mobility & 3D Transit Platform

> Intelligent 3D spatial navigation, real-time civic detour orchestration, and urban transit platform for Nagpur.  
> Built with **React 18**, **Mapbox GL JS 3D**, **Flutter 3 / Dart**, and **PostgreSQL / Supabase**.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-18.x-61dafb.svg)](https://reactjs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev/)
[![Mapbox](https://img.shields.io/badge/Mapbox-GL_JS_v3-000000.svg)](https://www.mapbox.com/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL_RLS-336791.svg)](https://www.postgresql.org/)

---

## 🏛️ System Overview

**ZeroMile Go** is a fullstack smart urban transit and civic corridor management platform designed for Nagpur. The application features a 3D digital-twin spatial engine that empowers everyday commuters to discover optimal routes around active civic rallies, cyclothons, and marathons, alongside a command studio for municipal route planning, emergency broadcasts, and checkpoint tracking.

### Core Capabilities

1. **3D Spatial Navigation & Forward Geocoding Engine**:
   * Mapbox GL JS v3 3D terrain rendering with dynamic sun-lighting controls and camera follow modes.
   * Forward geocoding with 250ms debouncing, `AbortController` cancellation, metropolitan coordinate boundary clamping (`78.5 < lng < 79.6`, `20.5 < lat < 21.6`), and offline landmark fallback.
2. **Dynamic Route Conflict & Detour Engine**:
   * Interactive origin-destination routing that detects active road closures (e.g. Wardha Road Cyclothon, Civil Lines Marathon).
   * Real-time turn-by-turn navigation HUD with remaining distance, ETA, and step cues.
3. **Dual Access Architecture**:
   * **Guest View (Zero-Login)**: Instant public access for citizens to explore routes, search places, and view municipal traffic advisories.
   * **SuperAdmin Command Studio**: Verified portal for municipal route builders to adjust waypoints, manage checkpoints, broadcast civic alerts, and dispatch emergency support.
4. **Cross-Platform Mobile Companion (`apps/mobile`)**:
   * Flutter 3 / Dart mobile application with offline-resilient architecture, emergency SOS radar FAB, and dynamic density maps.
5. **Hardened Backend & Security**:
   * PostgreSQL schemas with Row Level Security (RLS) enforcing role-based permissions (SuperAdmin, Leader, Participant).
   * Clean separation between public read-only views and authenticated municipal mutations.

---

## 📂 Project Architecture

```text
ZeroMile Go/
├── apps/
│   ├── web/                    # React 18 + Vite + TypeScript + Tailwind 3D Web Studio
│   │   ├── src/
│   │   │   ├── components/     # Landing page, layout headers, location search input
│   │   │   ├── features/       # 3D map, transit navigation, route studio, admin, SOS
│   │   │   ├── services/       # Geocoding, directions, Supabase, Nagpur registry
│   │   │   └── context/        # Auth, Domain, and Toast state providers
│   │   └── tests/              # Automated integration and geocoding test suites
│   │
│   └── mobile/                 # Flutter 3.29 + Dart Cross-Platform Mobile Client
│       └── lib/
│           ├── core/           # API services, mock fallback, shared models, themes
│           └── features/       # Admin, leader, participant, police, profile screens
│
├── database/                   # Canonical PostgreSQL Schemas & Migrations
│   ├── complete_setup.sql      # Consolidated schema and RLS policies
│   ├── seed.sql                # Deterministic UUID seeds and municipal nodes
│   └── migrations/             # Versioned DDL migrations (01 to 04)
│
├── docs/                       # Architecture & System Flow Documentation
│   ├── ARCHITECTURE.md         # Component hierarchy and data flow model
│   ├── SYSTEM_FLOW.md          # State machines and user journey diagrams
│   └── PROJECT_PLAN.md         # Product roadmap and specifications
│
├── shared/                     # Cross-Platform Data Contracts
│   └── types/domain_contracts.ts # Shared TypeScript interfaces
│
├── .env.example                # Sanitized environment configuration template
└── .gitignore                  # Production security and build ignore rules
```

---

## 🚀 Quick Start Guide

### Prerequisites
* **Node.js** v18+ & **npm**
* **Flutter SDK** v3.20+ (for mobile)
* Public Mapbox Access Token ([mapbox.com](https://account.mapbox.com/))

---

### 1. Web Application (`apps/web`)

```bash
# 1. Navigate to web directory
cd apps/web

# 2. Install dependencies
npm install

# 3. Configure environment variables
# Copy .env.example to .env and insert your public Mapbox token
cp .env.example .env

# 4. Start the local development server
npm run dev

# 5. Run automated unit & integration test suites
npm test

# 6. Build production bundle
npm run build
```

* **Local Dev Server**: `http://127.0.0.1:5173/`
* **Guest Exploration**: Click **"Guest View (No Login)"** to explore the full 3D transit studio without credentials.
* **SuperAdmin Dev Access**: Click **"SuperAdmin Portal"** and enter a registered phone number (e.g. `9823012345` from seed).

---

### 2. Mobile Application (`apps/mobile`)

```bash
# 1. Navigate to mobile directory
cd apps/mobile

# 2. Get Flutter packages
flutter pub get

# 3. Run static analysis
flutter analyze lib

# 4. Launch on connected device or emulator
flutter run
```

---

### 3. Database Setup (`database/`)

To provision a fresh PostgreSQL / Supabase database:
1. Open your Supabase or PostgreSQL SQL editor.
2. Execute [`database/complete_setup.sql`](database/complete_setup.sql) to create all tables, triggers, and Row Level Security policies.
3. Run [`database/seed.sql`](database/seed.sql) to populate initial Nagpur event domains, checkpoints, and corridors.

---

## 🧪 Testing & Verification

The project includes automated test coverage for geocoding sanitization, registry fallbacks, coordinate bounding, and domain contracts:

```bash
cd apps/web
npm test
```

Test Suites:
* `geocoding.test.cjs`: Validates query input sanitization, coordinate bounds, Mapbox/registry deduplication, and keyboard navigation.
* `integration.test.cjs`: Validates landmark resolution, deterministic UUID integrity, role verification, and route waypoint sequencing.

---

## 🔒 Security & Data Protection

* **Zero Hardcoded Secrets**: Client applications strictly read tokens from environment variables; private service keys are never bundled.
* **Row Level Security (RLS)**: PostgreSQL tables are locked down with fine-grained policies allowing public read access for safety bulletins while requiring admin credentials for modifications.
* **Input Sanitization**: User inputs and geocoding queries are sanitized and clamped to prevent injection and bounding box overflow.

---

## 📄 License & Attribution

This project is open-source under the [MIT License](LICENSE).  
Map data & vector tiles © [Mapbox](https://www.mapbox.com/) • © [OpenStreetMap](https://www.openstreetmap.org/copyright).

**Author & Maintainer**: [Yashraj Nikam](https://github.com/yashraj1310)  
**Repository**: [https://github.com/yashraj1310/zeromile-go](https://github.com/yashraj1310/zeromile-go)
