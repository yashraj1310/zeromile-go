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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.speed_rounded, size: 16, color: AppColors.domainCycling),
                  SizedBox(width: 8),
                  Text('LIVE CONTINGENT TELEMETRY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _telemetryTile('19.2 km/h', 'Avg Team Speed', AppColors.domainCycling),
                  _telemetryTile('4.2 km', 'Lead Rider Gap', AppColors.domainMarathon),
                  _telemetryTile('2', 'Stragglers / SOS', AppColors.sosRed),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Heartbeat Frequency: 5s (Throttle Active)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      foregroundColor: AppColors.domainCycling,
                      side: const BorderSide(color: AppColors.domainCycling),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: const Icon(Icons.my_location, size: 14),
                    label: const Text('Recenter Lead', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Centered viewport on Lead Rider (Aniket Deshmukh - Km 4.2)')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Lagging / Straggler Alert Tile
        GlassCard(
          borderColor: AppColors.warningAmber,
          backgroundColor: const Color(0x2EFF9100),
          child: Row(
            children: [
              const Icon(Icons.access_time_filled_rounded, color: AppColors.warningAmber, size: 22),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Straggler Detected: Rahul Mehra', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Standstill for > 4 mins at Km 1.2. Battery at 14%.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warningAmber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dispatched nearby marshal to assist Rahul Mehra.')),
                  );
                },
                child: const Text('Check', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _telemetryTile(String val, String label, Color accent) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent, fontFamily: 'monospace')),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
