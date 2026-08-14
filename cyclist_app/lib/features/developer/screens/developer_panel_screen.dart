import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/universal_nav_drawer.dart';
import '../tabs/dev_global_analytics_tab.dart';
import '../tabs/dev_provisioning_tab.dart';

class DeveloperPanelScreen extends StatefulWidget {
  const DeveloperPanelScreen({super.key});

  @override
  State<DeveloperPanelScreen> createState() => _DeveloperPanelScreenState();
}

class _DeveloperPanelScreenState extends State<DeveloperPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                Text('DEVELOPER MASTER PANEL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                Text('Cross-Domain Orchestration & Seating', style: TextStyle(fontSize: 10, color: AppColors.domainParade, fontWeight: FontWeight.w600)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.domainParade.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.domainParade.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: AppColors.domainParade),
                  SizedBox(width: 4),
                  Text('ROOT LEVEL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.domainParade)),
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
                color: AppColors.domainParade,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.domainParade.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.vpn_key_rounded, size: 14), SizedBox(width: 6), Text('Provisioning')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.insights_rounded, size: 14), SizedBox(width: 6), Text('Global Stats')])),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DevProvisioningTab(),
          DevGlobalAnalyticsTab(),
        ],
      ),
    );
  }
}
