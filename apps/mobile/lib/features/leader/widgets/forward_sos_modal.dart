import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';

class ForwardSosModal extends StatefulWidget {
  final SosEvent sosEvent;
  const ForwardSosModal({super.key, required this.sosEvent});

  @override
  State<ForwardSosModal> createState() => _ForwardSosModalState();
}

class _ForwardSosModalState extends State<ForwardSosModal> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
                    child: const Icon(Icons.arrow_forward_rounded, color: AppColors.sosRed, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESCALATE SOS TO SUPERADMIN',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.sosRed, letterSpacing: 0.5),
                        ),
                        Text(
                          'Forward rider emergency to city dispatch triage',
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 Rider: ${widget.sosEvent.senderName} (${widget.sosEvent.senderPhone})',
                      style: TextStyle(fontSize: 12.5, color: textCol, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '🚨 Incident Type: ${widget.sosEvent.emergencyType.name.toUpperCase()}',
                      style: const TextStyle(fontSize: 11, color: AppColors.sosRed, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text('ATTACH ESCALATION NOTE FOR SUPERADMIN *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5)),
              const SizedBox(height: 8),

              TextField(
                controller: _noteController,
                maxLines: 3,
                style: TextStyle(color: textCol, fontSize: 12.5),
                decoration: InputDecoration(
                  hintText: 'e.g. Requires aid van dispatched immediately to Shankar Nagar Square.',
                  hintStyle: TextStyle(color: textMuted, fontSize: 11),
                  filled: true,
                  fillColor: bgElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderCol)),
                ),
              ),
              const SizedBox(height: 18),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sosRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text('ESCALATE TO SUPERADMIN TRIAGE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                onPressed: () {
                  final note = _noteController.text.trim();
                  service.forwardSosToAdmin(
                    widget.sosEvent.id,
                    note.isEmpty ? 'Escalated by Group Leader for SuperAdmin dispatch.' : note,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.sosRed,
                      behavior: SnackBarBehavior.floating,
                      content: Text('↗️ SOS Escalated to SuperAdmin Governance Queue!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
