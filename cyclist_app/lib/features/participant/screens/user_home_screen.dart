import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/static_route_preview_map.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../widgets/active_group_card.dart';
import '../widgets/broadcast_ticker_card.dart';
import '../widgets/sos_trigger_dialog.dart';

/// Screen 1: Participant Home Dashboard (Active Event Window HUD)
/// Screen 1B: Participant Home Dashboard (Pre/Post Inactive Window)
/// Strictly adhering to PROJECT_PLAN.md Section 2 (Screens 1 & 1B)
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final domain = service.currentDomain;
        final isLive = service.isDomainLive;
        final broadcasts = service.broadcasts;
        final activeGroup = service.activeSubGroup;
        final isDark = service.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.menu_rounded, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.domainCycling.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.domainCycling.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '🚲 ${domain.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.domainCycling,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle Live Event Mode (Demo)',
                icon: Icon(
                  isLive ? Icons.timer_outlined : Icons.play_circle_fill_rounded,
                  color: isLive ? AppColors.domainMarathon : AppColors.sosRed,
                ),
                onPressed: () {
                  service.toggleDomainLiveStatus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isLive ? AppColors.sosRed : AppColors.domainMarathon,
                      content: Text(
                        isLive ? '⏱️ Event status changed to INACTIVE (Pre-Event Preview)' : '🟢 Event status changed to LIVE ACTIVE HUD',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Rally Pass & Profile',
                icon: Icon(Icons.qr_code_2_rounded, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
          body: isLive
              ? _buildActiveLiveHud(context, service, domain, broadcasts, activeGroup, isDark)
              : _buildInactivePreview(context, service, domain, broadcasts, isDark),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentBottomNavIndex,
              backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
              selectedItemColor: isDark ? AppColors.domainCycling : const Color(0xFF0284C7),
              unselectedItemColor: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() => _currentBottomNavIndex = index);
                if (index == 1) Navigator.pushNamed(context, '/groups');
                if (index == 2) Navigator.pushNamed(context, '/profile');
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Home Map'),
                BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Sub-Groups'),
                BottomNavigationBarItem(icon: Icon(Icons.badge_rounded), label: 'Pass & Links'),
              ],
            ),
          ),
          floatingActionButton: isLive
              ? Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: FloatingActionButton.extended(
                    elevation: 8,
                    backgroundColor: AppColors.sosRed,
                    icon: const Icon(Icons.sos_rounded, color: Colors.white, size: 28),
                    label: const Text(
                      'EMERGENCY SOS',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const SosTriggerDialog(),
                      );
                    },
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildActiveLiveHud(
    BuildContext context,
    MockDataService service,
    dynamic domain,
    List<dynamic> broadcasts,
    dynamic activeGroup,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // 1. Live Vector Route Map
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const DynamicDensityMapView(
                routeCoords: [
                  {'lat': 21.1458, 'lng': 79.0882},
                  {'lat': 21.1350, 'lng': 79.0700},
                  {'lat': 21.1280, 'lng': 79.0550},
                  {'lat': 21.1150, 'lng': 79.0400},
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.domainMarathon, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record, color: AppColors.domainMarathon, size: 10),
                      SizedBox(width: 4),
                      Text('LIVE ACTIVE GPS HUD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. Upcoming Checkpoints Quick Row
        Row(
          children: [
            Expanded(
              child: _checkpointCard(
                icon: Icons.water_drop_rounded,
                title: 'Water Point 1',
                distance: 'Shankar Nagar (2.1 km)',
                accent: AppColors.domainCycling,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _checkpointCard(
                icon: Icons.local_hospital_rounded,
                title: 'Medical Post',
                distance: 'Law College Sq (4.8 km)',
                accent: AppColors.sosRed,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3. Prioritized Broadcast Feed
        BroadcastTickerCard(broadcasts: service.broadcasts),
        const SizedBox(height: 12),

        // 4. Active Sub-Group Card
        ActiveGroupCard(
          activeGroup: activeGroup,
          onManageGroupsTap: () => Navigator.pushNamed(context, '/groups'),
        ),
      ],
    );
  }

  Widget _buildInactivePreview(
    BuildContext context,
    MockDataService service,
    dynamic domain,
    List<dynamic> broadcasts,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Inactive Schedule Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: AppColors.domainCycling, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'EVENT WINDOW: INACTIVE / UPCOMING',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Sunday, 15-Nov-2026 • 06:00 AM - 11:30 AM IST',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 4),
              const Text(
                'Live GPS telemetry tracking and SOS dispatch will automatically activate when Domain SuperAdmins initiate flag-off.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. Static Route Preview Map
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: const StaticRoutePreviewMap(),
        ),
        const SizedBox(height: 14),

        // 3. Enrolled Sub-Groups Quick Hub
        ActiveGroupCard(
          activeGroup: service.activeSubGroup,
          onManageGroupsTap: () => Navigator.pushNamed(context, '/groups'),
        ),
        const SizedBox(height: 14),

        // 4. Past Announcements
        BroadcastTickerCard(broadcasts: service.broadcasts),
      ],
    );
  }

  Widget _checkpointCard({
    required IconData icon,
    required String title,
    required String distance,
    required Color accent,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  distance,
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
