import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';

class DomainBroadcastDialog extends StatefulWidget {
  const DomainBroadcastDialog({super.key});

  @override
  State<DomainBroadcastDialog> createState() => _DomainBroadcastDialogState();
}

class _DomainBroadcastDialogState extends State<DomainBroadcastDialog> {
  final _msgController = TextEditingController();
  bool _targetGeneral = true;

  @override
  void dispose() {
    _msgController.dispose();
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
            const Row(
              children: [
                Icon(Icons.campaign_rounded, color: AppColors.sosRed, size: 24),
                SizedBox(width: 10),
                Text(
                  'SUPERADMIN BROADCAST TOOL',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Text('Broadcast Target:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Domain-Wide (General)', style: TextStyle(fontSize: 11)),
                  selected: _targetGeneral,
                  selectedColor: AppColors.sosRed,
                  onSelected: (val) => setState(() => _targetGeneral = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Sub-Groups Only', style: TextStyle(fontSize: 11)),
                  selected: !_targetGeneral,
                  selectedColor: AppColors.domainCycling,
                  onSelected: (val) => setState(() => _targetGeneral = false),
                ),
              ],
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _msgController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. 🚨 EMERGENCY TRAFFIC DIVERSION: Shankar Nagar junction congested. Follow Marshal pilot left.',
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final text = _msgController.text.trim();
                if (text.isNotEmpty) {
                  service.sendBroadcast(
                    text: text,
                    isGeneral: _targetGeneral,
                    senderRole: 'SUPERADMIN',
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.sosRed,
                      content: Text('🚨 High-Priority Domain Broadcast published to all participants & watch HUDs!'),
                    ),
                  );
                }
              },
              child: const Text('🚨 SEND HIGH-PRIORITY BROADCAST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
