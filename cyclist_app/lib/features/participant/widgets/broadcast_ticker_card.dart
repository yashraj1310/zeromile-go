import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

class BroadcastTickerCard extends StatelessWidget {
  final List<BroadcastMessage> broadcasts;

  const BroadcastTickerCard({
    super.key,
    required this.broadcasts,
  });

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = service.themeMode == ThemeMode.dark;

    if (broadcasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      borderColor: AppColors.domainProtest.withValues(alpha: 0.3),
      backgroundColor: isDark ? const Color(0x1AFF9100) : const Color(0x0FFF9100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign_rounded, color: AppColors.domainProtest, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'LATEST BROADCASTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.domainProtest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('LIVE ALERTS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.domainProtest)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...broadcasts.take(2).map((msg) {
            final isSuperAdmin = msg.senderRole.toUpperCase() == 'SUPERADMIN';
            final accentColor = isSuperAdmin ? AppColors.sosRed : AppColors.domainCycling;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border(left: BorderSide(color: accentColor, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSuperAdmin ? '🚨 SUPERADMIN' : '📣 LEADER NOTE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor),
                      ),
                      Text(
                        _formatTime(msg.createdAt),
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    msg.messageText,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
