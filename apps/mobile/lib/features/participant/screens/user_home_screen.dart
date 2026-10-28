import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/static_route_preview_map.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../widgets/active_group_card.dart';
import '../widgets/broadcast_ticker_card.dart';
import '../widgets/interactive_checkpoint_carousel.dart';
import '../widgets/nagpur_hero_carousel.dart';
import '../widgets/pulsing_sos_radar_fab.dart';

/// Screen 1: Participant Home Dashboard (Active Event Window HUD)
/// Screen 1B: Participant Home Dashboard (Pre/Post Inactive Window)
/// Modernized with Nagpur Landmark Image Transitions, Dynamic Light/Dark Theme, and Radar SOS.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgSurface = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final domain = service.currentDomain;
        final isLive = service.isCurrentDomainLive;
        final broadcasts = service.broadcasts;
        final activeGroup = service.activeSubGroup;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 66,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: textCol,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.royalPurple.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🚲 ', style: TextStyle(fontSize: 12)),
                        Flexible(
                          child: Text(
                            domain.name.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.royalPurple,
                              fontWeight: FontWeight.w900,
                              fontSize: 10.5,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Theme Toggle (☀️ Light / 🌙 Dark)
              IconButton(
                tooltip: service.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderCol),
                  ),
                  child: Icon(
                    service.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    color: service.isDarkMode ? AppColors.sunnyGold : AppColors.policeBlue,
                    size: 17,
                  ),
                ),
                onPressed: () => service.toggleTheme(),
              ),

              // Live Mode Toggle (Demo Simulation)
              IconButton(
                tooltip: 'Toggle Live Event Mode (Demo)',
                icon: Icon(
                  isLive ? Icons.timer_outlined : Icons.play_circle_fill_rounded,
                  color: isLive ? AppColors.vibrantEmerald : AppColors.solarOrange,
                  size: 24,
                ),
                onPressed: () {
                  service.forceLiveWindow = !service.forceLiveWindow;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  service.notifyListeners();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: service.forceLiveWindow ? AppColors.vibrantEmerald : AppColors.solarOrange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      content: Text(
                        service.forceLiveWindow
                            ? '🟢 Event status changed to LIVE ACTIVE HUD'
                            : '⏱️ Event status changed to INACTIVE (Pre-Event Preview)',
                        style: AppTypography.buttonLabel(color: Colors.white).copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Profile & Rally Pass Icon
              IconButton(
                tooltip: 'Rally Pass & Profile',
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderCol),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppColors.solarOrange,
                    size: 18,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
            children: [
              // 1. Nagpur Landmark Route & Circuit Carousel
              const NagpurHeroCarousel(),
              const SizedBox(height: 16),

              // 2. ACTIVE EVENT WINDOW HUD vs INACTIVE PREVIEW WINDOW
              if (isLive) ...[
                // Live Dynamic Density & Route Map Container
                _buildLiveMapSection(isDark),
                const SizedBox(height: 16),

                // Checkpoints & Aid Stations Horizontal Carousel
                const InteractiveCheckpointCarousel(),
              ] else ...[
                // Inactive Event Notification Schedule Banner
                _buildInactiveNotificationBanner(domain, isDark),
                const SizedBox(height: 16),

                // Static Route Preview Map
                _buildInactiveMapSection(domain, isDark),
              ],
              const SizedBox(height: 16),

              // 3. Active Sub-Group Card
              ActiveGroupCard(
                activeGroup: activeGroup,
                onChangeGroupTap: () => Navigator.pushNamed(context, '/groups'),
                onOpenHubTap: () => Navigator.pushNamed(context, '/leader'),
              ),
              const SizedBox(height: 16),

              // 4. Prioritized Broadcast Feed
              BroadcastTickerCard(broadcasts: broadcasts),
            ],
          ),

          // Bottom Navigation Bar (Home Map, Sub-Groups, Pass & Links)
          bottomNavigationBar: _buildBottomNavigationBar(isDark),

          // Floating Emergency SOS Action Button with Animated Radar Waves (Only in Live Event)
          floatingActionButton: isLive ? const PulsingSosRadarFab() : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  // --- Live Active GPS Map Container ---
  Widget _buildLiveMapSection(bool isDark) {
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderCol,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const DynamicDensityMapView(),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: cardBg.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.vibrantEmerald.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fiber_manual_record, color: AppColors.vibrantEmerald, size: 10),
                  const SizedBox(width: 6),
                  Text(
                    'LIVE ACTIVE GPS HUD',
                    style: TextStyle(
                      color: textCol,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Inactive Event Notification Schedule Banner (Screen 1B) ---
  Widget _buildInactiveNotificationBanner(dynamic domain, bool isDark) {
    final cardBg = isDark ? AppColors.surfaceGlassDark : AppColors.surfaceGlassLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderCol,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.solarOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.solarOrange, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVENT INACTIVE • SCHEDULED WINDOW',
                      style: AppTypography.chipLabel(color: AppColors.solarOrange).copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Rally Starts at 06:00 AM IST (Sunday)',
                      style: TextStyle(
                        color: textCol,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Live GPS tracking, density visualization, and SOS dispatch will activate automatically during the scheduled rally window. Review your course and contingent muster point below.',
            style: TextStyle(fontSize: 11.5, color: textMuted, height: 1.35),
          ),
        ],
      ),
    );
  }

  // --- Inactive Static Route Preview Map ---
  Widget _buildInactiveMapSection(dynamic domain, bool isDark) {
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderCol,
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: StaticRoutePreviewMap(routeSummary: domain.routeSummary),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavigationBar(bool isDark) {
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          top: BorderSide(
            color: borderCol,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _currentBottomNavIndex,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.solarOrange.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.solarOrange),
            label: 'Home Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded, color: AppColors.solarOrange),
            label: 'Sub-Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded, color: AppColors.solarOrange),
            label: 'Pass & Links',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() => _currentBottomNavIndex = index);
          if (index == 1) {
            Navigator.pushNamed(context, '/groups');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
