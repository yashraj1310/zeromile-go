import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/dynamic_density_map_view.dart';
import '../../../core/widgets/glass_card.dart';

class LeaderLiveMapTab extends StatelessWidget {
  const LeaderLiveMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Live Team GPS Canvas with Leader Scope
        Container(
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderCol),
          ),
          clipBehavior: Clip.antiAlias,
          child: const DynamicDensityMapView(
            title: 'VNIT Cycling Club Live GPS',
            isLeaderScope: true,
            height: 290,
          ),
        ),
        const SizedBox(height: 14),

        // Contingent Course Waypoint Card
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderColor: AppColors.solarOrange.withValues(alpha: 0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.solarOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on_rounded, size: 18, color: AppColors.solarOrange),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CONTINGENT ROUTE WAYPOINTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: textCol,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bgElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderCol),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MUSTER POINT', style: TextStyle(fontSize: 9.5, color: textMuted, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text('Ambazari Gate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textCol)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bgElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderCol),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DESTINATION', style: TextStyle(fontSize: 9.5, color: textMuted, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text('Futala Lake', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textCol)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: borderCol, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 3.5, backgroundColor: AppColors.solarOrange),
                      const SizedBox(width: 6),
                      Text(
                        'Live Route: Zero Mile Loop (24.5 km)',
                        style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.solarOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                    ),
                    icon: const Icon(Icons.my_location_rounded, size: 14),
                    label: const Text('Recenter Map', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.solarOrange,
                          content: Text('✓ Centered map on Ambazari assembly cluster'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Assembly Area Support Note Tile
        GlassCard(
          padding: const EdgeInsets.all(14),
          borderColor: AppColors.sunnyGold.withValues(alpha: 0.4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.sunnyGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_rounded, color: AppColors.sunnyGold, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assembly Notice for VNIT Contingent',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: textCol),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All riders gather at Ambazari South Gate for bib check-in by 06:00 AM.',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
