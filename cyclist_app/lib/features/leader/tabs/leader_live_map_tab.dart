import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';

class LeaderLiveMapTab extends StatelessWidget {
  const LeaderLiveMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Live Team GPS Canvas with Leader Scope
        const DynamicDensityMapView(
          title: 'VNIT Cycling Club Live GPS',
          isLeaderScope: true,
          height: 290,
        ),
        const SizedBox(height: 14),

        // Team Telemetry Metrics Card
        GlassCard(
          borderColor: AppColors.domainCycling.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.speed_rounded, size: 18, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('LIVE CONTINGENT TELEMETRY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _telemetryTile('19.2 km/h', 'Avg Team Speed', AppColors.domainCycling),
                  _telemetryTile('4.2 km', 'Lead Rider Gap', AppColors.domainMarathon),
                  _telemetryTile('2', 'Stragglers / SOS', AppColors.sosRed),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: AppColors.domainCycling),
                      SizedBox(width: 6),
                      Text('GPS Telemetry Frequency: 5s', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: AppColors.domainCycling,
                      side: BorderSide(color: AppColors.domainCycling.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.my_location_rounded, size: 14),
                    label: const Text('Recenter Lead', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.domainCycling,
                          content: Text('✓ Centered viewport on Lead Rider (Aniket Deshmukh - Km 4.2)'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Lagging / Straggler Alert Tile
        GlassCard(
          borderColor: AppColors.warningAmber,
          backgroundColor: const Color(0x2EFF9100),
          boxShadow: [
            BoxShadow(
              color: AppColors.warningAmber.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warningAmber.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time_filled_rounded, color: AppColors.warningAmber, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Straggler Flagged: Rahul Mehra', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('Standstill for > 4 mins at Km 1.2 • Phone battery 14%', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warningAmber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.support_agent_rounded, size: 14),
                label: const Text('Assist', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.warningAmber,
                      content: Text('🛠️ Dispatched nearby marshal escort to assist Rahul Mehra.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _telemetryTile(String val, String label, Color accent) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: accent, fontFamily: 'monospace')),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
