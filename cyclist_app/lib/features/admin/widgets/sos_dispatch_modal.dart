import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class SosDispatchModal extends StatelessWidget {
  final SosEvent sosEvent;
  const SosDispatchModal({super.key, required this.sosEvent});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.sosRed.withOpacity(0.6), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 22),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMERGENCY DISPATCH UNIT',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.sosRed, letterSpacing: 0.5),
                      ),
                      Text(
                        'Select emergency vehicle or marshal response unit',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Incident: ${sosEvent.emergencyType.name.toUpperCase()}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'ID: ${sosEvent.id}',
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '👤 ${sosEvent.senderName} (${sosEvent.senderPhone})',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  if (sosEvent.leaderNotes != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Leader Escalation Note: "${sosEvent.leaderNotes}"',
                        style: const TextStyle(fontSize: 11, color: Colors.amberAccent, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('SELECT DISPATCH UNIT:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 10),

            _dispatchOption(
              context,
              icon: Icons.airport_shuttle_rounded,
              title: '🚑 Event Ambulance #2 (Law College Tent)',
              subtitle: 'ETA: 3 mins (0.8 km away) • Siren Clearance',
              accent: AppColors.sosRed,
              onTap: () {
                service.resolveSos(sosEvent.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.sosRed,
                    content: Text('🚑 Event Ambulance #2 dispatched with siren clearance!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            _dispatchOption(
              context,
              icon: Icons.car_repair_rounded,
              title: '🛠️ Mobile Tech Support Van #1',
              subtitle: 'Equipped with spare chains, tubes & toolkits',
              accent: AppColors.warningAmber,
              onTap: () {
                service.resolveSos(sosEvent.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.warningAmber,
                    content: Text('🛠️ Support Van #1 dispatched to rider coordinates!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            _dispatchOption(
              context,
              icon: Icons.two_wheeler_rounded,
              title: '👮 Motorbike Marshal Escort #4',
              subtitle: 'Rapid traffic pilot & first-aid escort',
              accent: AppColors.policeBlue,
              onTap: () {
                service.resolveSos(sosEvent.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.policeBlue,
                    content: Text('👮 Motorbike Marshal #4 dispatched!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dispatchOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accent),
          ],
        ),
      ),
    );
  }
}
