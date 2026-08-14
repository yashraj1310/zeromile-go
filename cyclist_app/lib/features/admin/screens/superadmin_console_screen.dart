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
        backgroundColor: AppColors.bgPrimary,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUPERADMIN: CYCLING DOMAIN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Gatekeeper Console • 5 Seated Admins', style: TextStyle(fontSize: 10, color: AppColors.domainProtest)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.domainProtest,
          labelColor: AppColors.domainProtest,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.shield_rounded, size: 16), text: 'Governance'),
            Tab(icon: Icon(Icons.map_rounded, size: 16), text: 'Live Map'),
            Tab(icon: Icon(Icons.alt_route_rounded, size: 16), text: 'Route'),
            Tab(icon: Icon(Icons.bar_chart_rounded, size: 16), text: 'Analytics'),
          ],
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
