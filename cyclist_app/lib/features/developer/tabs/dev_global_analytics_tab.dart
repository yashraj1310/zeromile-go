import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class DevGlobalAnalyticsTab extends StatelessWidget {
  const DevGlobalAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. All Domains Overview
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.public_rounded, size: 16, color: AppColors.domainParade),
                  SizedBox(width: 8),
                  Text('GLOBAL CROSS-DOMAIN OVERVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metric('4', 'Active Tenants'),
                  _metric('5,498', 'Global Users'),
                  _metric('52', 'Sub-Groups'),
                  _metric('16', 'SuperAdmins'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Domain-by-Domain Breakdown
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.layers_rounded, size: 16, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('DOMAIN-BY-DOMAIN REGISTERED TRAFFIC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 12),
              _domainRow('🚲 Nagpur Cycling Rally 2026', '1,248 Users (22.7%)', AppColors.domainCycling),
              _domainRow('🏃 Nagpur City Marathon', '3,400 Users (61.8%)', AppColors.domainMarathon),
              _domainRow('📢 Citizen Peace & Civic Rally', '850 Users (15.5%)', AppColors.domainProtest),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Infrastructure & Telemetry Health
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.dns_rounded, size: 16, color: AppColors.policeBlue),
                  SizedBox(width: 8),
                  Text('INFRASTRUCTURE PIPELINE & LOAD HEALTH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 12),
              _healthItem('🔌 WebSocket Gateway', '2,140 Live Concurrent Streams', AppColors.domainMarathon),
              _healthItem('⚡ Geolocation Ping Latency', '48ms (Sub-50ms SLA Met)', AppColors.domainCycling),
              _healthItem('🗄️ PostgreSQL Connection Pool', '22% Utilized (Healthy)', AppColors.domainMarathon),
              _healthItem('🧠 Redis In-Memory Geo Cache', '14.2 MB / 512 MB (Optimal)', AppColors.domainMarathon),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceCard,
                  foregroundColor: AppColors.domainParade,
                  side: const BorderSide(color: AppColors.domainParade),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.sync_rounded, size: 18),
                label: const Text('🔄 Refresh Metrics', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Global telemetry telemetry refreshed.')));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceCard,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.borderSubtle),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('📥 Export DB Stats', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('DB Diagnostics report exported.')));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _metric(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _domainRow(String name, String stat, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          Text(stat, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _healthItem(String title, String value, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Row(
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor, fontFamily: 'monospace')),
            ],
          ),
        ],
      ),
    );
  }
}
