import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/static_route_preview_map.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../widgets/active_group_card.dart';
import '../widgets/broadcast_ticker_card.dart';
import '../widgets/sos_trigger_dialog.dart';

/// Screen 1 & 1B: Participant Home Dashboard
/// Conforming strictly to PROJECT_PLAN.md wireframe specifications.
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with SingleTickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        final isLive = service.isCurrentDomainLive;
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
                icon: const Icon(Icons.menu_rounded, size: 24),
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isLive ? AppColors.densityModerate : AppColors.textMuted,
                    shape: BoxShape.circle,
                    boxShadow: isLive
                        ? [
                            BoxShadow(
                              color: AppColors.densityModerate.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentDomain.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              // Temporal Simulation Switch (Active vs Concluded/Pre-Event)
              IconButton(
                icon: Icon(
                  isLive ? Icons.timer_rounded : Icons.timer_off_outlined,
                  color: isLive ? AppColors.domainCycling : AppColors.textMuted,
                  size: 22,
                ),
                tooltip: isLive ? 'Simulating Active Window (Live GPS & SOS Active)' : 'Simulating Inactive Window (Static Preview & SOS Hidden)',
                onPressed: () {
                  service.toggleTemporalSimulation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                      content: Text(
                        service.isCurrentDomainLive
                            ? '🟢 Simulating: Active Event Window (GPS & SOS On)'
                            : '⚪ Simulating: Pre/Post Event Window (Static Mode, SOS Off)',
                        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),

              // Notification Bell with unread badge (2)
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.sosRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. INACTIVE/CONCLUDED TEMPORAL BANNER (Screen 1B)
                if (!isLive) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
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
                            const Icon(Icons.event_available_rounded, size: 16, color: AppColors.domainCycling),
                            const SizedBox(width: 8),
                            Text(
                              '🏁 EVENT STATUS: PRE-EVENT / CONCLUDED',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Schedule: 15-Nov-2026 (06:00 AM - 11:30 AM) • Live telemetry and emergency SOS buttons are active strictly during official hours.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 2. ROUTE MAP (Dynamic Vector Density Map if LIVE, Static Preview if INACTIVE)
                if (isLive)
                  const DynamicDensityMapView(
                    title: 'Interactive Live Rally Route Map',
                    showSosPins: true,
                    height: 240,
                  )
                else
                  StaticRoutePreviewMap(
                    routeSummary: currentDomain.routeSummary,
                    height: 180,
                  ),

                const SizedBox(height: 12),

                // 3. ROUTE CHECKPOINT QUICK CARDS
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ROUTE CHECKPOINTS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '24.5 km Total',
                            style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.domainCycling.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.domainCycling.withOpacity(0.25)),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('💧 Water Point 1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.domainCycling)),
                                  SizedBox(height: 2),
                                  Text('Shankar Nagar Sq (2 km)', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.sosRed.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.sosRed.withOpacity(0.25)),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('🚑 Medical Post', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.sosRed)),
                                  SizedBox(height: 2),
                                  Text('Law College Sq (5 km)', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 4. LATEST PRIORITIZED BROADCASTS FEED
                BroadcastTickerCard(broadcasts: service.broadcasts),

                const SizedBox(height: 12),

                // 5. ACTIVE SUB-GROUP CARD
                ActiveGroupCard(
                  activeGroup: activeGroup,
                  onChangeGroupTap: () {
                    Navigator.pushNamed(context, '/groups');
                  },
                  onOpenHubTap: () {
                    Navigator.pushNamed(context, '/leader');
                  },
                ),

                const SizedBox(height: 80), // Padding for floating elements
              ],
            ),
          ),

          // 6. FLOATING EMERGENCY SOS ACTION BUTTON (Rendered ONLY in LIVE Active Window)
          floatingActionButton: isLive
              ? ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sosRed.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: FloatingActionButton.large(
                      backgroundColor: AppColors.sosRed,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SosTriggerDialog(
                            activeSubGroupName: activeGroup?.name,
                            isGroupLeaderAssigned: activeGroup != null,
                          ),
                        );
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 28),
                          SizedBox(height: 2),
                          Text(
                            'SOS',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,

          // 7. BOTTOM NAVIGATION BAR
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
              border: Border(top: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight)),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentBottomNavIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.domainCycling,
              unselectedItemColor: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() => _currentBottomNavIndex = index);
                if (index == 1) {
                  // Navigate to Groups
                  Navigator.pushNamed(context, '/groups');
                } else if (index == 2) {
                  // Navigate to Profile & Pass
                  Navigator.pushNamed(context, '/profile');
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.navigation_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_rounded),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_rounded),
                  label: 'Pass & Links',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
