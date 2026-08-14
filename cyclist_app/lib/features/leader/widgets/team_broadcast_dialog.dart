import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';

class TeamBroadcastDialog extends StatefulWidget {
  final String groupName;
  const TeamBroadcastDialog({super.key, required this.groupName});

  @override
  State<TeamBroadcastDialog> createState() => _TeamBroadcastDialogState();
}

class _TeamBroadcastDialogState extends State<TeamBroadcastDialog> {
  final _msgController = TextEditingController();

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
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppColors.domainCycling, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'BROADCAST TO ${widget.groupName.toUpperCase()}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This broadcast will be delivered directly to the active HUDs of your 38 team members.',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _msgController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Assemble at South Gate by 05:30 AM sharp! Check tyre pressures.',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppColors.surfaceCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainCycling,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final text = _msgController.text.trim();
                if (text.isNotEmpty) {
                  service.sendBroadcast(
                    text: text,
                    isGeneral: false,
                    targetGroupName: widget.groupName,
                    senderRole: 'GROUP_LEADER',
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('📣 Broadcast sent to ${widget.groupName}!')),
                  );
                }
              },
              child: const Text('📣 SEND TEAM BROADCAST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
