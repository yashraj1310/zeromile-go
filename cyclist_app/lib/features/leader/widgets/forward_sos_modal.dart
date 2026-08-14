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

    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.sosRed, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_forward_rounded, color: AppColors.sosRed, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'ESCALATE SOS TO SUPERADMIN',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.sosRed),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Participant: ${widget.sosEvent.senderName} (${widget.sosEvent.senderPhone})',
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              'Emergency: ${widget.sosEvent.emergencyType.name.toUpperCase()}',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),

            const Text('Attach Escalation Note for SuperAdmin *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'e.g. Unconscious rider, require ambulance dispatched immediately to Shankar Nagar.',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sosRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final note = _noteController.text.trim();
                service.forwardSosToAdmin(widget.sosEvent.id, note.isNotEmpty ? note : 'Forwarded by Group Leader');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.sosRed,
                    content: Text('↗️ SOS Escalated to SuperAdmin Emergency Queue!'),
                  ),
                );
              },
              child: const Text('↗️ FORWARD TO SUPERADMIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
