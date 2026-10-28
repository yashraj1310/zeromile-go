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
        side: BorderSide(color: AppColors.vibrantEmerald.withValues(alpha: 0.4), width: 1.5),
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
                      color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.vibrantEmerald, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTINGENT BROADCAST',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                        ),
                        Text(
                          'Target: ${widget.groupName} (38 Riders)',
                          style: const TextStyle(fontSize: 10.5, color: AppColors.vibrantEmerald, fontWeight: FontWeight.w800),
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
                  color: bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol),
                ),
                child: Text(
                  '📢 Broadcast advisory will appear as a high-priority alert on the home feeds of all 38 contingent members.',
                  style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _msgController,
                maxLines: 3,
                style: TextStyle(color: textCol, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Gather at Ambazari South Gate by 05:45 AM for helmet inspection and muster roll call.',
                  hintStyle: TextStyle(color: textMuted, fontSize: 11.5),
                  filled: true,
                  fillColor: bgElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderCol),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vibrantEmerald,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text('TRANSMIT TO CONTINGENT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                onPressed: () {
                  final text = _msgController.text.trim();
                  if (text.isNotEmpty) {
                    service.publishBroadcast(
                      text: text,
                      isGeneral: false,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.vibrantEmerald,
                        behavior: SnackBarBehavior.floating,
                        content: Text('✓ Broadcast sent to all ${widget.groupName} members!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
