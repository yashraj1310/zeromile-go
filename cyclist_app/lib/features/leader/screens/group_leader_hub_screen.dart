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
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GROUP LEADER HUB',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                ),
                Text(
                  '🎓 VNIT Cycling Club • Leader: Rajesh Sharma',
                  style: TextStyle(fontSize: 10, color: AppColors.domainMarathon, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.domainMarathon.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.domainMarathon.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: AppColors.domainMarathon),
                  SizedBox(width: 4),
                  Text('38 MEMBERS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.domainMarathon)),
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
                color: AppColors.domainMarathon,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.domainMarathon.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.groups_rounded, size: 15), SizedBox(width: 6), Text('Team Hub')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map_rounded, size: 15), SizedBox(width: 6), Text('Live Map')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bar_chart_rounded, size: 15), SizedBox(width: 6), Text('Analytics')])),
              ],
            ),
          ),
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
