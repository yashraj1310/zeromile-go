import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/widgets/glass_card.dart';

class BroadcastTickerCard extends StatelessWidget {
  final List<BroadcastMessage> broadcasts;

  const BroadcastTickerCard({super.key, required this.broadcasts});

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) {
      return const SizedBox.shrink();
    }

    final latest = broadcasts.first;
    final isSuperAdmin = latest.senderRole == 'SUPERADMIN';

    return GlassCard(
      borderColor: isSuperAdmin ? AppColors.sosRed.withOpacity(0.4) : AppColors.domainCycling.withOpacity(0.3),
      backgroundColor: isSuperAdmin ? const Color(0x33FF1744) : const Color(0x1F00F2FE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSuperAdmin ? Icons.campaign_rounded : Icons.record_voice_over_rounded,
                size: 16,
                color: isSuperAdmin ? AppColors.sosRed : AppColors.domainCycling,
              ),
              const SizedBox(width: 8),
              Text(
                isSuperAdmin ? '🚨 OFFICIAL DOMAIN BROADCAST' : '📣 TEAM LEADER NOTE (${latest.targetGroupName ?? ""})',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSuperAdmin ? AppColors.sosRed : AppColors.domainCycling,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            latest.messageText,
            style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.3),
          ),
          const SizedBox(height: 4),
          Text(
            'From: ${latest.senderName} • ${_timeAgo(latest.createdAt)}',
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}
