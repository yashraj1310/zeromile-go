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
                  child: const Icon(Icons.arrow_forward_rounded, color: AppColors.sosRed, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESCALATE SOS TO SUPERADMIN',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.sosRed, letterSpacing: 0.5),
                      ),
                      Text(
                        'Forward rider emergency to domain command queue',
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
                  Text(
                    '👤 Rider: ${widget.sosEvent.senderName} (${widget.sosEvent.senderPhone})',
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '🚨 Incident Type: ${widget.sosEvent.emergencyType.name.toUpperCase()}',
                    style: const TextStyle(fontSize: 11, color: AppColors.sosRed, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('ATTACH ESCALATION NOTE FOR SUPERADMIN *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'e.g. Unconscious rider, require ambulance dispatched immediately to Shankar Nagar Square.',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.sosRed.withOpacity(0.6)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sosRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: AppColors.sosRed.withOpacity(0.4),
              ),
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('↗️ FORWARD TO SUPERADMIN QUEUE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
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
            ),
          ],
        ),
      ),
    );
  }
}
