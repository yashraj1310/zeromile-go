import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../tabs/admin_analytics_tab.dart';
import '../tabs/admin_governance_tab.dart';
import '../tabs/admin_live_map_tab.dart';
import '../tabs/admin_route_builder_tab.dart';
import '../widgets/domain_broadcast_dialog.dart';

class SuperadminConsoleScreen extends StatefulWidget {
  const SuperadminConsoleScreen({super.key});

  @override
  State<SuperadminConsoleScreen> createState() => _SuperadminConsoleScreenState();
}

class _SuperadminConsoleScreenState extends State<SuperadminConsoleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final domain = service.currentDomain;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const UniversalNavDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 74,
            titleSpacing: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: textCol,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUPERADMIN COMMAND',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            fontSize: 14,
                            color: textCol,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Domain: ${domain.name}',
                          style: const TextStyle(
                            color: AppColors.royalPurple,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.vibrantEmerald.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: AppColors.vibrantEmerald),
                        SizedBox(width: 4),
                        Text(
                          'LIVE ACTIVE',
                          style: TextStyle(
                            color: AppColors.vibrantEmerald,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: bgElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderCol),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.royalBlue, AppColors.royalPurple],
                        ),
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.royalPurple.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: textMuted,
                      labelStyle: AppTypography.chipLabel().copyWith(fontSize: 10, fontWeight: FontWeight.w800),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(child: Text('Triage')),
                        Tab(child: Text('Map')),
                        Tab(child: Text('Route')),
                        Tab(child: Text('Stats')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AdminGovernanceTab(),
                  AdminLiveMapTab(),
                  AdminRouteBuilderTab(),
                  AdminAnalyticsTab(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.royalPurple,
            foregroundColor: Colors.white,
            elevation: 3,
            icon: const Icon(Icons.campaign_rounded, size: 18),
            label: const Text(
              'BROADCAST TO CITY',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DomainBroadcastDialog(),
              );
            },
          ),
        );
      },
    );
  }
}
