# 🏛️ Vikasit Nagpur: Master UI/UX Blueprint (100% UI Team Division)

> **Official UI Development Blueprint for 3 UI Engineers**  
> *Target: Multi-Platform UI (Flutter Mobile, React Public Web, Smartwatch UI)*

---

## ⌚ 1. Is the Smartwatch Idea Feasible & Implementable?

> [!IMPORTANT]
> **YES! ABSOLUTELY 100% FEASIBLE & A MASSIVE HACKATHON WINNER.**
> 
> ### Why it's feasible and how we do it easily today:
> 1. **Flutter Circular Viewport:** In Flutter, a Smartwatch interface is built as a specialized circular/square UI widget (`smartwatch_hud_screen.dart`) optimized for 1.4-inch round screens (e.g. 240x240px circular canvas with giant high-contrast digits and a 3-second hold SOS emergency dial).
> 2. **Zero Complex Hardware Dependencies:** For the hackathon pitch, you can either:
>    - Run it on a **Wear OS Emulator** in Android Studio.
>    - Or display the **Smartwatch Live HUD** inside a realistic Apple Watch / Galaxy Watch frame right on your mobile screen or web dashboard!
> 3. **Why Judges Will Love It:** Judges rarely see smartwatch safety integrations. Showing an active cyclist tapping a watch SOS button on stage while the admin screen immediately flashes red creates an instant **"WOW" factor** that wins hackathons!

---

## 👥 2. 3-Person UI Division & Exact File Ownership

All 3 team members are focusing **100% on UI engineering**. Here is the exact file ownership mapping so no two people touch the same file:

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        3-PERSON UI OWNERSHIP MATRIX                          │
├──────────────────────┬──────────────────────┬────────────────────────────────┤
│ 🌐 PERSON 1          │ 📱 PERSON 2          │ 🛠️ PERSON 3                    │
│ Public Web & Guest   │ Participant & Watch  │ Admin, Marshal & Police        │
├──────────────────────┼──────────────────────┼────────────────────────────────┤
│ • Public Web Viewer  │ • Participant HUD    │ • Event Admin Studio           │
│ • Mode Switcher UI   │ • Smartwatch UI      │ • SOS Triage Modal             │
│ • App Guest Home     │ • Telemetry Counters │ • Marshal Roster Screen        │
│ • Phone OTP Login    │ • Floating SOS FX    │ • Police Command Dashboard     │
└──────────────────────┴──────────────────────┴────────────────────────────────┘
```

---

### 🌐 PERSON 1: Public Web & Guest Experience UI Lead
**Focus:** Build the zero-login public experience (Web & Mobile) and Phone OTP login.

#### Exact Files Person 1 Will Edit:
1. `web-public/src/components/PublicWebViewer.tsx` (Desktop Public Map Viewer)
2. `web-public/src/components/PublicNavBar.tsx` (Web Mode Switcher: 🚴 Cycling | 🏃 Marathon | 🚶 Walkathon | 🎪 Parade)
3. `web-public/src/components/BroadcastDrawer.tsx` (Collapsible Live Broadcast Feed drawer)
4. `cyclist_app/lib/features/guest/screens/guest_home_screen.dart` (Mobile Guest Home with blurred Nagpur map)
5. `cyclist_app/lib/features/auth/screens/phone_otp_screen.dart` (Glassmorphic OTP Login Screen)

#### AI Prompt for Person 1:
> *"Design and polish the public experience UI: 1) Build the desktop public web viewer (`PublicWebViewer.tsx`) in React + Vite with dark mode #090D16, top mode switcher pills, full map viewport with cyan route polyline, and right-hand collapsible broadcast feed drawer. 2) In Flutter, polish `guest_home_screen.dart` with a blurred Nagpur landmark map backdrop, horizontal event mode pills, and 3D parallax tilt event cards. 3) Polish `phone_otp_screen.dart` with a centered glassmorphic card, +91 pre-filled input, and 6 square OTP input boxes."*

---

### 📱 PERSON 2: Participant Telemetry & Smartwatch UI Lead
**Focus:** Build the active sports telemetry HUD, live map tracking UI, and Smartwatch companion face.

#### Exact Files Person 2 Will Edit:
1. `cyclist_app/lib/features/participant/screens/participant_hub_screen.dart` (Hero Participant Live Activity HUD)
2. `cyclist_app/lib/features/watch/screens/smartwatch_hud_screen.dart` (Wear OS / Smartwatch circular telemetry HUD)
3. `cyclist_app/lib/core/widgets/sos_button.dart` (Floating Red Circular SOS Button with multi-ring pulse animation)
4. `cyclist_app/lib/core/widgets/parallax_tilt.dart` (3D Mouse/Gyro Cursor Tilt Effect for telemetry cards)
5. `cyclist_app/lib/core/widgets/live_badge.dart` (Animated pulsing red 'LIVE NOW' badge)

#### AI Prompt for Person 2:
> *"Design and polish the sports telemetry and smartwatch UI: 1) In `participant_hub_screen.dart`, build a Strava-style HUD bar with Speed (24.5 km/h) in JetBrains Mono font, Distance (12.4 km), and Pace counters. Add a top sliding organizer broadcast banner tile, live map container, and bottom right floating 64x64px red SOS button with multi-ring breathing pulse. 2) In `smartwatch_hud_screen.dart`, build a circular 240x240px Wear OS watch face UI with giant speed digits, distance chip, and a high-contrast 3-second hold red SOS dial."*

---

### 🛠️ PERSON 3: Admin Studio, Marshal & Police Command UI Lead
**Focus:** Build the organizer route painter, emergency triage dialogs, marshal roster, and police advisory dashboard.

#### Exact Files Person 3 Will Edit:
1. `cyclist_app/lib/features/admin/screens/admin_dashboard_screen.dart` (Organizer Route Painter & Studio)
2. `cyclist_app/lib/features/admin/widgets/sos_triage_modal.dart` (High-priority Red SOS Emergency Incident Triage Dialog)
3. `cyclist_app/lib/features/marshal/screens/marshal_roster_screen.dart` (Safety Marshal sub-pack member list with battery & pace indicators)
4. `cyclist_app/lib/features/police/screens/police_dashboard_screen.dart` (Traffic Police Command Center with Junction ETA cards)
5. `cyclist_app/lib/core/widgets/custom_map_markers.dart` (Custom map symbol builder: 🚴 Cyclist, 🏃 Runner, 💧 Water, 🚑 Medical, 👮 Police)

#### AI Prompt for Person 3:
> *"Design and polish the admin, marshal, and police command UI: 1) In `admin_dashboard_screen.dart`, create an interactive route creator toolbar over map canvas, broadcast publisher modal, and pinned bottom red alert card for active SOS emergencies with [Call], [Navigate], [Resolve] buttons. 2) In `marshal_roster_screen.dart`, build a sub-pack roster with summary chips (Active, Lagging, SOS), member cards with battery % and status dots, and a bottom 'Scan QR' button. 3) In `police_dashboard_screen.dart`, build multi-event map view, junction arrival prediction cards with ETA countdowns, and a police advisory broadcast composer."*

---

## 🎨 3. Dual Theme Design Tokens (Shared Reference for All 3)

Located in `cyclist_app/lib/core/constants/app_colors.dart`:

```css
/* Dark Mode Tokens (Default Hackathon Theme) */
--bg-primary: #090D16;          /* Deep Space Navy */
--surface-card: #131B2E;         /* Slate Glass Card */
--surface-glass: rgba(19, 27, 46, 0.75); /* 75% Translucent Blur */
--border-subtle: rgba(255, 255, 255, 0.08); /* 1px Subtlest Border */

/* Accent Colors */
--accent-cyan: #00F2FE;          /* Cycling & Primary Telemetry */
--accent-emerald: #00E676;       /* Marathon & Active State */
--accent-amber: #FF9100;         /* Walkathon & Advisory */
--accent-purple: #D500F9;        /* Parade & Processions */
--sos-red: #FF1744;              /* SOS Emergency Glow */
--police-blue: #2979FF;          /* Police Advisories */
```

---

## 📁 4. Clean Folder Structure & File Map

```
vikasit-nagpur/
├── cyclist_app/
│   ├── lib/
│   │   ├── main.dart                       # Route registry
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   │   ├── app_colors.dart         # Shared Theme Tokens
│   │   │   │   ├── app_typography.dart     # Shared Google Fonts
│   │   │   │   └── app_theme.dart          # Dark & Light Themes
│   │   │   └── widgets/
│   │   │       ├── glass_card.dart         # Shared Glass Container
│   │   │       ├── parallax_tilt.dart      # [PERSON 2] 3D Tilt Effect
│   │   │       ├── sos_button.dart         # [PERSON 2] Glowing SOS
│   │   │       ├── live_badge.dart         # [PERSON 2] Pulse Badge
│   │   │       └── custom_map_markers.dart # [PERSON 3] Map SVG Markers
│   │   └── features/
│   │       ├── guest/screens/
│   │       │   └── guest_home_screen.dart  # [PERSON 1] Blurred Map Home
│   │       ├── auth/screens/
│   │       │   └── phone_otp_screen.dart   # [PERSON 1] OTP Login
│   │       ├── participant/screens/
│   │       │   └── participant_hub_screen.dart # [PERSON 2] Telemetry HUD
│   │       ├── watch/screens/
│   │       │   └── smartwatch_hud_screen.dart  # [PERSON 2] Smartwatch UI
│   │       ├── admin/
│   │       │   ├── screens/admin_dashboard_screen.dart # [PERSON 3] Admin Studio
│   │       │   └── widgets/sos_triage_modal.dart       # [PERSON 3] SOS Modal
│   │       ├── marshal/screens/
│   │       │   └── marshal_roster_screen.dart          # [PERSON 3] Marshal Screen
│   │       └── police/screens/
│   │           └── police_dashboard_screen.dart        # [PERSON 3] Police Command
└── web-public/
    └── src/
        └── components/
            ├── PublicWebViewer.tsx         # [PERSON 1] Web Map View
            ├── PublicNavBar.tsx            # [PERSON 1] Mode Switcher Pills
            └── BroadcastDrawer.tsx         # [PERSON 1] Broadcast Feed Drawer
```

---

## ⏱️ 5. 24-Hour UI Execution Plan

1. **Hours 00–02:** Push skeleton to GitHub. Each person creates their git branch:
   - `git checkout -b feature/person1-public-ui`
   - `git checkout -b feature/person2-telemetry-watch-ui`
   - `git checkout -b feature/person3-admin-police-ui`
2. **Hours 02–14:** Build and polish the assigned UI screens.
3. **Hours 14–18:** Add micro-animations (`flutter_animate`), hover effects, and parallax tilt.
4. **Hours 18–22:** Merge all 3 branches into `main` and test transitions.
5. **Hours 22–24:** Demo rehearsal with mobile, web, and smartwatch UI side-by-side!
