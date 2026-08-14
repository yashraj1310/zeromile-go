import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// SOS Emergency Incident Triage Dialog (Person 3)
class SosTriageModal extends StatelessWidget {
  final String participantName;
  final String bibNumber;
  final String locationName;
  final VoidCallback onResolve;

  const SosTriageModal({
    super.key,
    this.participantName = 'Rahul Sharma',
    this.bibNumber = '142',
    this.locationName = 'Near High Court Chowk',
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: GlassCard(
        customBorder: Border.all(color: AppColors.sosRed, width: 2),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        color: AppColors.sosRed.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: AppColors.sosRed, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Text('CRITICAL SOS ALERT', style: TextStyle(color: AppColors.sosRed, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('$participantName (Bib #$bibNumber)', style: AppTypography.h3),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.cyanElectric, size: 16),
                const SizedBox(width: 4),
                Text(locationName, style: AppTypography.bodyMedium),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.phone, size: 18, color: AppColors.cyanElectric),
                    label: const Text('Call Rider'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldNeon,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Resolve', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      onResolve();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
