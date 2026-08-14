import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

class AdminRouteBuilderTab extends StatelessWidget {
  const AdminRouteBuilderTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. EVENT SCHEDULE & TIMINGS
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 16, color: AppColors.domainCycling),
                      SizedBox(width: 8),
                      Text('1. EVENT SCHEDULE & TEMPORAL WINDOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _fieldRow('Event Date', '15-Nov-2026 (Sunday)'),
                  _fieldRow('Start Time', '06:00 AM (Flag-off)'),
                  _fieldRow('End Time', '11:30 AM (Course Cleared)'),
                  _fieldRow('Lifecycle Status', 'UPCOMING / SCHEDULED'),
                  const SizedBox(height: 8),
                  const Text(
                    'ℹ️ Live map telemetry streaming and emergency SOS triggers will activate strictly during this configured temporal window.',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 2. ROUTE GEOMETRY & CHECKPOINTS
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.alt_route_rounded, size: 16, color: AppColors.domainMarathon),
                          SizedBox(width: 8),
                          Text('2. ROUTE CHECKPOINTS & AID POSTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.domainMarathon.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('24.5 km Loop', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainMarathon)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...service.checkpoints.map((cp) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHover,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '#${cp.sequenceOrder}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cp.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                  Text('Lat: ${cp.latitude.toStringAsFixed(4)}, Lng: ${cp.longitude.toStringAsFixed(4)}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 8),

                  // Add Checkpoints Toolbar
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _actionChip('+ 💧 Water Station', AppColors.domainCycling, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Click map coordinate to drop Water Station.')));
                      }),
                      _actionChip('+ 🚑 Medical Tent', AppColors.sosRed, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Click map coordinate to drop Medical Tent.')));
                      }),
                      _actionChip('+ ⛔ Road Closure', AppColors.warningAmber, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Click road segment to mark Diversion.')));
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Publish Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainCycling,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.cloud_upload_rounded, size: 18),
              label: const Text('💾 PUBLISH OFFICIAL ROUTE & SCHEDULE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.domainCycling,
                    content: Text('✓ Official Route & Schedule published to GeoJSON and synced to all devices!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _fieldRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  static Widget _actionChip(String label, Color color, VoidCallback onTap) {
    return ActionChip(
      backgroundColor: color.withOpacity(0.15),
      label: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      side: BorderSide(color: color.withOpacity(0.5)),
      onPressed: onTap,
    );
  }
}
