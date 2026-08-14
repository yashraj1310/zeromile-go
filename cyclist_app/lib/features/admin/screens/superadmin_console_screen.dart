import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../tabs/admin_analytics_tab.dart';
import '../tabs/admin_governance_tab.dart';
import '../tabs/admin_live_map_tab.dart';
import '../tabs/admin_route_builder_tab.dart';

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
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      drawer: const UniversalNavDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPERADMIN CONSOLE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                ),
                Text(
                  '🚲 Cycling Domain • 5 Provisioned Gatekeepers',
                  style: TextStyle(fontSize: 10, color: AppColors.domainCycling, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.domainCycling.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.domainCycling.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: AppColors.domainMarathon),
                  SizedBox(width: 5),
                  Text('LIVE ACTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.domainCycling)),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.domainCycling,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.domainCycling.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shield_rounded, size: 14), SizedBox(width: 4), Text('Governance')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map_rounded, size: 14), SizedBox(width: 4), Text('Live Map')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.alt_route_rounded, size: 14), SizedBox(width: 4), Text('Route')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bar_chart_rounded, size: 14), SizedBox(width: 4), Text('Analytics')])),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AdminGovernanceTab(),
          AdminLiveMapTab(),
          AdminRouteBuilderTab(),
          AdminAnalyticsTab(),
        ],
      ),
    );
  }
}
