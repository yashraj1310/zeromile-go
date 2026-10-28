import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

class AdminRouteBuilderTab extends StatelessWidget {
  const AdminRouteBuilderTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // 1. EVENT SCHEDULE & TIMINGS
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.royalPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.schedule_rounded, size: 18, color: AppColors.royalPurple),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'EVENT SCHEDULE & LIFECYCLE WINDOW',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _fieldRow('Event Date', '15-Nov-2026 (Sunday)', textCol, textMuted),
                  _fieldRow('Start Time', '06:00 AM (Flag-off at Zero Mile)', textCol, textMuted),
                  _fieldRow('Course Cleared', '11:30 AM (Finish Line at Futala)', textCol, textMuted),
                  _fieldRow('Lifecycle Mode', 'ACTIVE LIVE EVENT', AppColors.vibrantEmerald, textMuted),
                  const SizedBox(height: 10),
                  Text(
                    'ℹ️ Live event map and emergency SOS escalation triggers are active strictly during this configured temporal window.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. ROUTE GEOMETRY & CHECKPOINTS
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.alt_route_rounded, size: 18, color: AppColors.vibrantEmerald),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'OFFICIAL COURSE WAYPOINTS & AID POSTS',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('24.5 km Circuit', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.vibrantEmerald)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  ...service.checkpoints.map((cp) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: bgElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderCol),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.royalPurple.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#${cp.sequenceOrder}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.royalPurple),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cp.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textCol)),
                                  Text('Lat: ${cp.latitude.toStringAsFixed(4)}, Lng: ${cp.longitude.toStringAsFixed(4)}', style: TextStyle(fontSize: 10.5, color: textMuted)),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle_outline, size: 16, color: AppColors.vibrantEmerald),
                          ],
                        ),
                      )),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.royalPurple,
                      side: BorderSide(color: AppColors.royalPurple.withValues(alpha: 0.6), width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_location_alt_rounded, size: 16),
                    label: const Text('+ Add Waypoint Checkpoint', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.royalPurple,
                          behavior: SnackBarBehavior.floating,
                          content: Text('📍 Click on the map to pin new Course Checkpoint'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _fieldRow(String label, String value, Color textCol, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textCol)),
        ],
      ),
    );
  }
}
