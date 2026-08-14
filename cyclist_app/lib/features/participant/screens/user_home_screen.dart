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
            backgroundColor: const Color(0xFF0F172A),
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentDomain.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: isLive ? AppColors.domainCycling : AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          isLive ? 'LIVE RALLY IN PROGRESS' : 'PRE-EVENT MODE',
                          style: TextStyle(fontSize: 9, color: isLive ? AppColors.domainCycling : AppColors.textMuted, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Temporal Window Simulator Toggle Button
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: isLive ? AppColors.domainCycling.withOpacity(0.15) : const Color(0xFF1E293B),
                  ),
                  icon: Icon(
                    isLive ? Icons.timer_outlined : Icons.timer_off_outlined,
                    color: isLive ? AppColors.domainCycling : AppColors.textMuted,
                    size: 20,
                  ),
                  tooltip: isLive ? 'Event Window ACTIVE (Tap to simulate outside window)' : 'Event Window INACTIVE (Tap to simulate live window)',
                  onPressed: () {
                    service.toggleTemporalSimulation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: service.isCurrentDomainLive ? AppColors.domainCycling : AppColors.surfaceCard,
                        content: Text(
                          service.isCurrentDomainLive
                              ? '🟢 Simulated: Active Event Window (GPS & SOS Enabled)'
                              : '⚪ Simulated: Pre/Post Event Window (Static Mode)',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.event_available_rounded, size: 16, color: AppColors.domainCycling),
                            SizedBox(width: 8),
                            Text('🏁 EVENT STATUS: PRE-EVENT SCHEDULE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Schedule: 15-Nov-2026 (06:00 AM - 11:30 AM) • Tap stopwatch icon at top-right to simulate live event mode.',
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
                  borderColor: AppColors.domainCycling.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.flag_circle_rounded, size: 18, color: AppColors.domainCycling),
                          SizedBox(width: 8),
                          Text('RALLY CHECKPOINTS & AID STATIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...service.checkpoints.map((cp) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.domainCycling.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'CP ${cp.sequenceOrder}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cp.name,
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
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
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sosRed.withOpacity(0.5),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    backgroundColor: AppColors.sosRed,
                    elevation: 6,
                    icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                    label: const Text(
                      '🚨 EMERGENCY SOS',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5, color: Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SosTriggerDialog(),
                      );
                    },
                  ),
                )
              : null,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF0F172A),
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
          ),
        );
      },
    );
  }
}
