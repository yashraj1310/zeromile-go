import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/widgets/glass_card.dart';

class BroadcastTickerCard extends StatelessWidget {
  final List<BroadcastMessage> broadcasts;

  const BroadcastTickerCard({
    super.key,
    required this.broadcasts,
  });

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return GlassCard(
      borderColor: AppColors.sunnyGold.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.sunnyGold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.sunnyGold, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE BROADCAST FEED',
                    style: TextStyle(
                      color: textCol,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.sunnyGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.sunnyGold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.sunnyGold,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.3, 1.3),
                          duration: 800.ms,
                        ),
                    const SizedBox(width: 5),
                    Text(
                      'REAL-TIME',
                      style: AppTypography.chipLabel(color: AppColors.sunnyGold).copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Broadcast Items
          ...broadcasts.take(2).map((msg) {
            final isSuperAdmin = msg.senderRole.toUpperCase() == 'SUPERADMIN';
            final accentColor = isSuperAdmin ? AppColors.popPink : AppColors.solarOrange;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  left: BorderSide(color: accentColor, width: 3.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isSuperAdmin ? Icons.shield_rounded : Icons.groups_rounded,
                            size: 13,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isSuperAdmin ? 'SUPERADMIN ANNOUNCEMENT' : 'CONTINGENT LEAD DISPATCH',
                            style: AppTypography.chipLabel(color: accentColor).copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 9.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatTime(msg.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    msg.messageText,
                    style: TextStyle(
                      color: textCol,
                      fontSize: 11.5,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
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
    return '$hour:$minute IST';
  }
}
