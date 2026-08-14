# 🏛️ Vikasit Nagpur: Official 3-Person UI Architecture & Ownership Blueprint

> **Official UI Engineering Guide for Yashraj, Shantanu, and Rakshit**  
> *Target: Multi-Tenant Rally & Event Platform (Flutter Mobile & React Public Web)*  
> *Strictly aligned with [PROJECT_PLAN.md](./PROJECT_PLAN.md) — 100% Zero-Overlap UI Division*

---

## 👥 1. Executive 3-Person Team Ownership Matrix

```text
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                 3-PERSON UI OWNERSHIP MATRIX                                     │
├──────────────────────────────┬──────────────────────────────┬────────────────────────────────────┤
│ 🌐 YASHRAJ                   │ 👥 SHANTANU                  │ 🛠️ RAKSHIT                         │
│ Participant & Civic Nav Lead │ Group Leader Hub Lead        │ Civic Command & Dev Panel Lead     │
├──────────────────────────────┼──────────────────────────────┼────────────────────────────────────┤
│ • User Home Dashboard (1/1B) │ • Group Leader 3-Tab Hub     │ • SuperAdmin 4-Tab Console         │
│ • Temporal Active/Inactive   │ • Tab 1: Team Hub & Triage   │ • Tab 1: Governance & Dispatch     │
│ • My Sub-Groups (Max 3 / 1)  │ • Tab 2: Live Team Map       │ • Tab 2: Domain Live Map (Filters) │
│ • Universal Nav Drawer       │ • Tab 3: Team Analytics      │ • Tab 3: Route & Schedule Builder  │
│ • Group Creation Request Form│ • Forward SOS Note Modal     │ • Tab 4: Domain Analytics & Audit  │
│ • Emergency SOS Trigger FAB  │ • Direct Add Member Dialog   │ • 👮 Traffic Police Command Center │
│ • 👤 Profile & Link Sharing  │ • Team Broadcast Composer    │ • Developer Master Panel (2 Tabs)  │
│ • Zero-Login Public Web App  │ • Muster Progress Analytics  │ • SuperAdmin Seating (5-6 Cap)     │
└──────────────────────────────┴──────────────────────────────┴────────────────────────────────────┘
```

---

## 📂 2. Exact Files Each Developer Will Alter

Every team member has **100% exclusive ownership** over their files so no merge conflicts happen.

### 🌐 YASHRAJ (Participant UI, Profile, Link Sharing & Public Web)
* `cyclist_app/lib/core/widgets/universal_nav_drawer.dart` (Drawer & Domain Switcher)
* `cyclist_app/lib/features/participant/screens/user_home_screen.dart` (Screen 1 & 1B)
* `cyclist_app/lib/features/participant/screens/groups_management_screen.dart` (Screen 2)
* `cyclist_app/lib/features/participant/screens/group_creation_request_screen.dart` (Screen 4)
* `cyclist_app/lib/features/participant/widgets/sos_trigger_dialog.dart`
* `cyclist_app/lib/features/participant/widgets/active_group_card.dart`
* `cyclist_app/lib/features/participant/widgets/broadcast_ticker_card.dart`
* `cyclist_app/lib/features/profile/screens/user_profile_screen.dart` (Profile, QR Pass, Theme Switch)
* `cyclist_app/lib/features/profile/widgets/link_sharing_modal.dart` (One-tap link copy)
* `web-public/src/components/PublicWebViewer.tsx` & `PublicNavBar.tsx`

---

### 👥 SHANTANU (Group Leader Hub & Team Telemetry)
* `cyclist_app/lib/features/leader/screens/group_leader_hub_screen.dart` (3-Tab Hub Shell)
* `cyclist_app/lib/features/leader/tabs/leader_team_hub_tab.dart` (Screen 5: SOS Triage & Roster)
* `cyclist_app/lib/features/leader/tabs/leader_live_map_tab.dart` (Screen 6: Team GPS & Stragglers)
* `cyclist_app/lib/features/leader/tabs/leader_analytics_tab.dart` (Screen 7: Muster % & CSV Export)
* `cyclist_app/lib/features/leader/widgets/forward_sos_modal.dart` (Escalate SOS to SuperAdmin)
* `cyclist_app/lib/features/leader/widgets/direct_add_member_dialog.dart` (Direct phone add)
* `cyclist_app/lib/features/leader/widgets/team_broadcast_dialog.dart` (Team broadcast tool)

---

### 🛠️ RAKSHIT (SuperAdmin Console, Traffic Police & Developer Panel)
* `cyclist_app/lib/features/admin/screens/superadmin_console_screen.dart` (4-Tab Admin Shell)
* `cyclist_app/lib/features/admin/tabs/admin_governance_tab.dart` (Screen 8: SOS Queue & Approvals)
* `cyclist_app/lib/features/admin/tabs/admin_live_map_tab.dart` (Screen 9: Sub-Group Filtered Map)
* `cyclist_app/lib/features/admin/tabs/admin_route_builder_tab.dart` (Screen 10: Route & Schedule)
* `cyclist_app/lib/features/admin/tabs/admin_analytics_tab.dart` (Screen 11: Domain Turnout & SLA)
* `cyclist_app/lib/features/admin/widgets/sos_dispatch_modal.dart` (Ambulance/Support Van dispatch)
* `cyclist_app/lib/features/admin/widgets/group_approval_dialog.dart` (Approve/Reject requests)
* `cyclist_app/lib/features/admin/widgets/domain_broadcast_dialog.dart` (High-priority alert tool)
* `cyclist_app/lib/features/police/screens/police_dashboard_screen.dart` (Traffic Police Command — *SOS excluded*)
* `cyclist_app/lib/features/developer/screens/developer_panel_screen.dart` (2-Tab Dev Panel Shell)
* `cyclist_app/lib/features/developer/tabs/dev_provisioning_tab.dart` (Screen 12: 5-6 SuperAdmin seating)
* `cyclist_app/lib/features/developer/tabs/dev_global_analytics_tab.dart` (Screen 13: Global Health)
* `cyclist_app/lib/features/developer/widgets/create_domain_modal.dart` (Create new tenant domain)

---

## 🎨 3. Design Uniformity & Dual Theme Engine (Dark + Light)

To maintain 100% design consistency across all screens:
1. **Always wrap custom surfaces in `GlassCard`** (`core/widgets/glass_card.dart`).
2. **Use curated color tokens from `AppColors`**:
   - `AppColors.domainCycling` (`#00F2FE` Cyan)
   - `AppColors.domainMarathon` (`#00E676` Emerald)
   - `AppColors.domainProtest` (`#FF9100` Amber)
   - `AppColors.policeBlue` (`#2979FF` Police Royal Blue)
   - `AppColors.sosRed` (`#FF1744` Emergency Red)
3. **Dynamic Theme Toggle**:
   - Both Dark Mode (`AppTheme.darkTheme`) and Light Mode (`AppTheme.lightTheme`) are fully configured.
   - Users can toggle theme mode seamlessly in their Profile screen or programmatically via `MockDataService().toggleTheme()`.

---

## 🚨 4. Critical Architecture Rules

### 1. Emergency SOS Routing (Police Exclusion Rule)
> [!IMPORTANT]
> **SOS IS NEVER SENT TO TRAFFIC POLICE.**
> * **Participant $\rightarrow$ Group Leader**: If active in a sub-group, SOS alerts their own leader first for local resolution (hydration, puncture).
> * **Leader $\rightarrow$ SuperAdmin**: If critical (heatstroke, crash), leader forwards with an escalation note to SuperAdmin triage.
> * **General User $\rightarrow$ SuperAdmin**: If not in a sub-group, SOS routes directly to SuperAdmin queue.
> * **SuperAdmin Dispatches**: Dispatches **Event Ambulances** or **Mobile Support Vans**.
> * **Traffic Police Scope**: Regulates **traffic flow, junction green corridors, and road closures**.

### 2. Group Membership Constraints
* **Max 3 Sub-Groups**: A participant can join at most 3 sub-groups per domain.
* **Exactly 1 Active Group**: A participant can have only 1 group toggled as active for live GPS tracking and SOS routing.

---

## 🔗 5. Profile & Encrypted Link Sharing

Located in `cyclist_app/lib/features/profile/`:
* **User Profile**: Displays verified participant credentials, blood group, and next-of-kin emergency contact.
* **Rally Pass QR**: Displays scan-ready QR code for check-in at muster points and finish line pavilion.
* **One-Tap Link Sharing**: Generates shareable URLs:
  - 🎫 *Live Rally Pass Link* (`https://vikasitnagpur.in/pass/...`)
  - 👥 *Contingent Live Tracking Link* (`https://vikasitnagpur.in/team/...`)
  - 🌐 *Public Spectator Web Map Link* (`https://vikasitnagpur.in/live/...`)

---

## 🚀 6. GitHub Push Instructions (Remove Old & Push Clean UI)

Run the following commands in your terminal to stage, commit, and push the clean UI architecture to GitHub:

```powershell
# 1. Navigate to workspace root
cd "c:\Users\yashr\OneDrive\Desktop\Vikasit Nagpur"

# 2. Check current status
git status

# 3. Stage all new files and record deletions of old prototype folders
git add -A

# 4. Commit with clean descriptive message
git commit -m "feat(ui): Complete multi-role UI architecture, dual theme engine, police command center, and 3-person role division"

# 5. Push to GitHub main branch
git push origin main
```

---

## 💬 7. Tailored Prompts for Each Team Member

### 🌐 For Yashraj:
> *"I am Yashraj, Participant & Civic Navigation Lead for Vikasit Nagpur. In `cyclist_app/lib/features/participant/` and `features/profile/`: 1) Polish the active/inactive temporal window transitions in `user_home_screen.dart`. 2) Refine the 1-Active group radio toggle switch in `groups_management_screen.dart`. 3) Polish the QR pass and link sharing cards in `user_profile_screen.dart` and `link_sharing_modal.dart`."*

### 👥 For Shantanu:
> *"I am Shantanu, Group Leader Hub Lead for Vikasit Nagpur. In `cyclist_app/lib/features/leader/`: 1) Polish the 3-tab layout in `group_leader_hub_screen.dart`. 2) In `leader_team_hub_tab.dart`, refine the SOS triage card with Call, Local Resolve, and Forward to Admin with note modal (`forward_sos_modal.dart`). 3) In `leader_live_map_tab.dart`, polish own-group density shading and lagging straggler warnings. 4) In `leader_analytics_tab.dart`, polish the muster roll check-in progress bar and CSV export action."*

### 🛠️ For Rakshit:
> *"I am Rakshit, Civic Command & Developer Lead for Vikasit Nagpur. In `cyclist_app/lib/features/admin/`, `features/police/`, and `features/developer/`: 1) Polish the 4-tab SuperAdmin Console (`superadmin_console_screen.dart`) with SOS ambulance/support van dispatch modals and group application approvals. 2) In `police_dashboard_screen.dart`, refine the junction arrival ETA countdowns and road advisory broadcast composer (remember: SOS is excluded from police). 3) In `developer_panel_screen.dart`, polish the 5-6 SuperAdmin seating provisioning tab and global cross-domain system health analytics tab."*
