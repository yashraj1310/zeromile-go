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
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.domainMarathon.withOpacity(0.5), width: 1.5),
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
                    color: AppColors.domainMarathon.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.campaign_rounded, color: AppColors.domainMarathon, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TEAM BROADCAST COMPOSER',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                      ),
                      Text(
                        'Target: ${widget.groupName} (38 Riders)',
                        style: const TextStyle(fontSize: 10, color: AppColors.domainMarathon, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Text(
                '📢 Broadcast advisory will appear as a high-priority push banner on the active HUDs of all 38 team members.',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _msgController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'e.g. Assemble at South Gate by 05:30 AM sharp! Check tyre pressures and gear.',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.domainMarathon.withOpacity(0.6)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainMarathon,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: AppColors.domainMarathon.withOpacity(0.3),
              ),
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('📢 DISPATCH TEAM BROADCAST', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
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
                    SnackBar(
                      backgroundColor: AppColors.domainMarathon,
                      content: Text('📣 Broadcast sent to all 38 members of ${widget.groupName}!'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
