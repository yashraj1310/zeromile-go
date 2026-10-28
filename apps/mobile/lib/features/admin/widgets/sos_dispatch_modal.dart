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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: AppColors.sosRed.withValues(alpha: 0.5), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
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
                      color: AppColors.sosRed.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_rounded, color: AppColors.sosRed, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMERGENCY DISPATCH UNIT',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.sosRed, letterSpacing: 0.5),
                        ),
                        Text(
                          'Select emergency vehicle or marshal response unit',
                          style: TextStyle(fontSize: 10.5, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderCol),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Incident: ${sosEvent.emergencyType.name.toUpperCase()}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textCol),
                        ),
                        Text(
                          'ID: ${sosEvent.id}',
                          style: TextStyle(fontSize: 10, color: textMuted, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '👤 ${sosEvent.senderName} (${sosEvent.senderPhone})',
                      style: TextStyle(fontSize: 11.5, color: textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('SELECT DISPATCH UNIT:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              _dispatchOption(
                context,
                title: '🚑 Ambulance #1 (Law College Sq)',
                subtitle: 'ETA: ~3 mins • Paramedic onboard',
                onDispatch: () {
                  service.resolveSos(sosEvent.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.vibrantEmerald,
                      behavior: SnackBarBehavior.floating,
                      content: Text('✓ Ambulance #1 dispatched! Response ETA ~3 mins.'),
                    ),
                  );
                },
                bgElevated: bgElevated,
                borderCol: borderCol,
                textCol: textCol,
                textMuted: textMuted,
              ),
              const SizedBox(height: 8),

              _dispatchOption(
                context,
                title: '🏍️ Rapid Response Motorcycle Unit',
                subtitle: 'ETA: ~1.5 mins • First aid & AED equipped',
                onDispatch: () {
                  service.resolveSos(sosEvent.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.vibrantEmerald,
                      behavior: SnackBarBehavior.floating,
                      content: Text('✓ Rapid Response Motorcycle Unit dispatched!'),
                    ),
                  );
                },
                bgElevated: bgElevated,
                borderCol: borderCol,
                textCol: textCol,
                textMuted: textMuted,
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgElevated,
                  foregroundColor: textCol,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  side: BorderSide(color: borderCol),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dispatchOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onDispatch,
    required Color bgElevated,
    required Color borderCol,
    required Color textCol,
    required Color textMuted,
  }) {
    return InkWell(
      onTap: onDispatch,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderCol),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textCol)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10.5, color: textMuted)),
              ],
            ),
            const Icon(Icons.send_rounded, size: 16, color: AppColors.sosRed),
          ],
        ),
      ),
    );
  }
}
