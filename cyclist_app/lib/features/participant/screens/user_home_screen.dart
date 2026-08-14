import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/static_route_preview_map.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../widgets/active_group_card.dart';
import '../widgets/broadcast_ticker_card.dart';
import '../widgets/sos_trigger_dialog.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentBottomTab = 0;

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        final isLive = service.isCurrentDomainLive;
        final activeGroup = service.activeSubGroup;

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors.bgPrimary,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  currentDomain.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              // Temporal Window Simulator Toggle Button
              IconButton(
                icon: Icon(
                  isLive ? Icons.timer_outlined : Icons.timer_off_outlined,
                  color: isLive ? AppColors.domainCycling : AppColors.textMuted,
                ),
                tooltip: isLive ? 'Event Window ACTIVE (Tap to simulate outside window)' : 'Event Window INACTIVE (Tap to simulate live window)',
                onPressed: () {
                  service.toggleTemporalSimulation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                        service.isCurrentDomainLive
                            ? '🟢 Simulated: Active Event Window (GPS & SOS Enabled)'
                            : '⚪ Simulated: Pre/Post Event Window (Static Mode)',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temporal Status Banner
                if (!isLive)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.event_available_rounded, size: 14, color: AppColors.domainCycling),
                            SizedBox(width: 6),
                            Text('🏁 EVENT STATUS: PRE-EVENT / CONCLUDED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Schedule: 15-Nov-2026 (06:00 AM - 11:30 AM) • Live tracking and SOS are active only during official hours.',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                // Map Viewport (Dynamic Density if Live, Static Polyline if Inactive)
                if (isLive)
                  const DynamicDensityMapView(
                    title: 'Interactive Live Rally Route Map',
                    showSosPins: true,
                    height: 250,
                  )
                else
                  StaticRoutePreviewMap(
                    routeSummary: currentDomain.routeSummary,
                    height: 200,
                  ),

                const SizedBox(height: 12),

                // Live Broadcast Ticker
                BroadcastTickerCard(broadcasts: service.broadcasts),

                const SizedBox(height: 12),

                // Active Sub-Group Card
                ActiveGroupCard(
                  activeGroup: activeGroup,
                  onChangeGroupTap: () {
                    Navigator.pushNamed(context, '/groups');
                  },
                  onOpenHubTap: () {
                    Navigator.pushNamed(context, '/leader');
                  },
                ),

                const SizedBox(height: 12),

                // Rally Checkpoints Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.flag_circle_rounded, size: 16, color: AppColors.domainCycling),
                          SizedBox(width: 8),
                          Text('RALLY CHECKPOINTS & AID STATIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...service.checkpoints.map((cp) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              '${cp.sequenceOrder}.',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cp.name,
                                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // Padding for floating SOS
              ],
            ),
          ),
          // Floating SOS Action Button (Rendered ONLY if event is LIVE)
          floatingActionButton: isLive
              ? FloatingActionButton.extended(
                  backgroundColor: AppColors.sosRed,
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                  label: const Text(
                    '🚨 EMERGENCY SOS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5, color: Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SosTriggerDialog(),
                    );
                  },
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.surfaceCard,
            selectedItemColor: AppColors.domainCycling,
            unselectedItemColor: AppColors.textMuted,
            currentIndex: _currentBottomTab,
            onTap: (index) {
              setState(() => _currentBottomTab = index);
              if (index == 2) {
                Navigator.pushNamed(context, '/groups');
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Groups'),
            ],
          ),
        );
      },
    );
  }
}
