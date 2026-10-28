# VIKASIT NAGPUR / ZEROMILE GO — SYSTEM & ROLE FLOW SPECIFICATION

## 1. Primary User Journey & State Transitions

```mermaid
flowchart TD
    Start([User visits zero.nagpur.gov.in]) --> Landing[Public Landing Page]
    Landing --> Explore[Dual Search Pill: Origin to Destination]
    Landing --> QuickChip[Select Civic Node: Zero Mile, VNIT, AIIMS, Futala]
    Landing --> ViewEvents[Explore Event Showcase: Cyclothon, Marathon, Procession]
    Landing --> OpenLogin[Click Gateway Login]

    Explore --> CommuterMode[Commuter Transit View]
    QuickChip --> CommuterMode

    CommuterMode --> PlanRoute[Calculate Commuter Route via Mapbox]
    PlanRoute --> CheckClash{Route Intersects Active Event Corridor?}
    CheckClash -- Yes --> ConflictCard[Display Red Conflict Warning Card + Detour Option]
    CheckClash -- No --> SafeRoute[Display Green Clear Highway + Navigation HUD]

    OpenLogin --> LoginModal{Select Login Role}
    LoginModal -- Commuter --> PhoneLogin[Enter Phone Number -> Instant Commuter Access]
    LoginModal -- SuperAdmin --> AdminOTP[Enter SuperAdmin Phone + 6-digit OTP]

    AdminOTP --> VerifyDB{Verify in public.users & domain_superadmins}
    VerifyDB -- Authorized --> SuperAdminMode[Enter SuperAdmin Corridor Studio]
    VerifyDB -- Denied --> AuthError[Access Denied Error Toast]
```

---

## 2. SuperAdmin Operational & Corridor Studio Flow

```mermaid
flowchart TD
    Studio[SuperAdmin Corridor Studio] --> Action{Choose Administrative Action}

    Action --> EditWaypoints[Drag Polyline Waypoints on 3D Map]
    EditWaypoints --> RecalcRoute[Mapbox API Recalculates Geometry & Distance]
    RecalcRoute --> SaveCorridor[Persist Route to Database]

    Action --> PoliceRoadblock[Toggle Police Barricade Mode]
    PoliceRoadblock --> ClickMap[Click Road on Map to Drop Hazard-Striped Barricade]
    ClickMap --> DetourCalc[System Automatically Computes Safe Detour Path]
    DetourCalc --> AlertPublic[Broadcast Road Closure Notification to Commuters]

    Action --> AddCheckpoint[Open Add Checkpoint Modal]
    AddCheckpoint --> SelectType[Choose: Water, Medical, Timing, Cheer, Start, Finish]
    SelectType --> PlaceMarker[Place Marker on Corridor & Save to DB]

    Action --> DispatchAlert[Open Civic Alert Broadcast Modal]
    DispatchAlert --> FillBroadcast[Enter Title, Severity, and Affected Zones]
    FillBroadcast --> PublishAlert[Publish Alert -> Active Red/Amber Top Banner]

    Action --> SwitchView[Switch to SuperAdmin Command Center]
    SwitchView --> Monitor[Monitor Real-Time Rider Telemetry, Speed & SOS Feed]
```

---

## 3. Real-Time Telemetry & SOS Emergency Escalation Flow

```mermaid
sequenceDiagram
    autonumber
    actor Rider as Cyclist / Mobile App
    participant Mobile as cyclist_app
    participant PostgREST as Supabase Backend
    participant WS as Realtime Channel
    participant Studio as Web Command Studio (SuperAdmin)

    Note over Rider,Mobile: Active Event Mode
    loop Every 3-5 Seconds
        Mobile->>PostgREST: POST /rest/v1/telemetry (lat, lng, speed, battery)
        PostgREST-->>WS: Broadcast to "telemetry:domain_id"
        WS-->>Studio: Update live rider pin & speed badge (e.g. 24.5 km/h)
    end

    alt Rider Encounters Medical or Mechanical Emergency
        Rider->>Mobile: Press SOS Emergency Button
        Mobile->>PostgREST: POST /rest/v1/sos_events (type: MEDICAL/CRASH, location)
        PostgREST-->>WS: Urgent Broadcast to "sos:domain_id"
        WS-->>Studio: Trigger Audio Alert & Red Flashing SOS Modal
        Studio->>Studio: SuperAdmin Dispatches Nearest Ambulance / Marshal
        Studio->>PostgREST: PATCH /rest/v1/sos_events (status: RESOLVED)
    end
```

---

## 4. Mapbox 3D Engine & Lighting State Flow

```mermaid
stateDiagram-v2
    [*] --> DayMode: Initial Load

    DayMode --> DawnMode: User selects 🌅 Dawn
    DawnMode --> DayMode: User selects ☀️ Day
    DayMode --> DuskMode: User selects 🌇 Dusk
    DuskMode --> NightMode: User selects 🌙 Night
    NightMode --> DayMode: User selects ☀️ Day

    state DayMode {
        [*] --> StandardDaylight
        StandardDaylight: High contrast, neutral sun lighting
    }
    state DawnMode {
        [*] --> MorningGlow
        MorningGlow: Low angle sunlight, soft orange glow
    }
    state DuskMode {
        [*] --> SunsetWarmth
        SunsetWarmth: Amber and violet twilight hues
    }
    state NightMode {
        [*] --> CyberpunkDark
        CyberpunkDark: Neon corridors, illuminated 3D building outlines
    }
```
