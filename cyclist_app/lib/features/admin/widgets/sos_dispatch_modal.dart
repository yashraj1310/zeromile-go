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
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.sosRed, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 24),
                SizedBox(width: 10),
                Text(
                  'EMERGENCY DISPATCH UNIT',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.sosRed),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Incident ID: ${sosEvent.id} • ${sosEvent.emergencyType.name.toUpperCase()}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Participant: ${sosEvent.senderName} (${sosEvent.senderPhone})',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            if (sosEvent.leaderNotes != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Leader Escalation Note: "${sosEvent.leaderNotes}"', style: const TextStyle(fontSize: 11, color: Colors.amberAccent)),
              ),
            const SizedBox(height: 16),

            const Text('Select Dispatch Unit:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),

            _dispatchOption(
              context,
              icon: Icons.airport_shuttle_rounded,
              title: '🚑 Event Ambulance #2 (Law College Tent)',
              subtitle: 'ETA: 3 mins (0.8 km away)',
              accent: AppColors.sosRed,
              onTap: () {
                service.resolveSos(sosEvent.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.sosRed,
                    content: Text('🚑 Ambulance #2 dispatched with siren clearance!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            _dispatchOption(
              context,
              icon: Icons.car_repair_rounded,
              title: '🛠️ Mobile Tech Support Van #1',
              subtitle: 'Equipped with spare chains, tubes, toolkits',
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
              subtitle: 'Rapid traffic pilot & first aid',
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accent.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.send_rounded, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
