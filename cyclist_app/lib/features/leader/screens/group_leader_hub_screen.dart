import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../tabs/leader_analytics_tab.dart';
import '../tabs/leader_live_map_tab.dart';
import '../tabs/leader_team_hub_tab.dart';

class GroupLeaderHubScreen extends StatefulWidget {
  const GroupLeaderHubScreen({super.key});

  @override
  State<GroupLeaderHubScreen> createState() => _GroupLeaderHubScreenState();
}

class _GroupLeaderHubScreenState extends State<GroupLeaderHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            Text('LEADER HUB: VNIT Cycling Club', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Contingent Leader: Rajesh Sharma', style: TextStyle(fontSize: 10, color: AppColors.domainMarathon)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.domainMarathon,
          labelColor: AppColors.domainMarathon,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.groups_rounded, size: 18), text: 'Team Hub'),
            Tab(icon: Icon(Icons.map_rounded, size: 18), text: 'Live Map'),
            Tab(icon: Icon(Icons.bar_chart_rounded, size: 18), text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LeaderTeamHubTab(),
          LeaderLiveMapTab(),
          LeaderAnalyticsTab(),
        ],
      ),
    );
  }
}
