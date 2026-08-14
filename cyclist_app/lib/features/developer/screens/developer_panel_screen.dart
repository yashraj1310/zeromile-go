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
        backgroundColor: AppColors.bgPrimary,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DEVELOPER MASTER PANEL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Cross-Domain Orchestration & Seating', style: TextStyle(fontSize: 10, color: AppColors.domainParade)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.domainParade,
          labelColor: AppColors.domainParade,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.vpn_key_rounded, size: 16), text: 'Provisioning'),
            Tab(icon: Icon(Icons.insights_rounded, size: 16), text: 'Global Stats'),
          ],
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
