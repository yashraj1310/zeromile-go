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
        side: BorderSide(color: AppColors.royalPurple.withValues(alpha: 0.4), width: 1.5),
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
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.royalPurple, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SUPERADMIN EVENT BROADCAST',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textCol, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Text('Broadcast Target:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textCol)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Participants', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    selected: _targetGeneral,
                    selectedColor: AppColors.royalPurple,
                    onSelected: (val) => setState(() => _targetGeneral = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Contingents Only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    selected: !_targetGeneral,
                    selectedColor: AppColors.solarOrange,
                    onSelected: (val) => setState(() => _targetGeneral = false),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _msgController,
                maxLines: 3,
                style: TextStyle(color: textCol, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. 📢 Traffic Advisory: Shankar Nagar diversion in effect. Follow route marshals.',
                  hintStyle: TextStyle(color: textMuted, fontSize: 11.5),
                  filled: true,
                  fillColor: bgElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderCol)),
                ),
              ),
              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  final text = _msgController.text.trim();
                  if (text.isNotEmpty) {
                    service.publishBroadcast(
                      text: text,
                      isGeneral: _targetGeneral,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.royalPurple,
                        behavior: SnackBarBehavior.floating,
                        content: Text('✓ Broadcast sent to all citizen ticker feeds!'),
                      ),
                    );
                  }
                },
                child: const Text('TRANSMIT BROADCAST', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
