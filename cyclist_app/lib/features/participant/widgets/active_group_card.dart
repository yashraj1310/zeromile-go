import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

class ActiveGroupCard extends StatelessWidget {
  final SubGroup? activeGroup;
  final VoidCallback onChangeGroupTap;
  final VoidCallback onOpenHubTap;

  const ActiveGroupCard({
    super.key,
    required this.activeGroup,
    required this.onChangeGroupTap,
    required this.onOpenHubTap,
  });

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = service.themeMode == ThemeMode.dark;

    if (activeGroup == null) {
      return GlassCard(
        borderColor: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.group_off_rounded, color: AppColors.textMuted, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Active Sub-Group',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  ),
                  const Text('Belonging to General Group. Tap to join or set active group.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.domainCycling,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onChangeGroupTap,
              child: const Text('Join Group', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      borderColor: AppColors.domainCycling.withValues(alpha: 0.4),
      backgroundColor: isDark ? const Color(0xCC131B2E) : const Color(0xF5FFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.radio_button_checked, size: 14, color: AppColors.domainCycling),
                  SizedBox(width: 6),
                  Text(
                    'YOUR ACTIVE SUB-GROUP',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.domainCycling, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.domainCycling.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${activeGroup!.memberCount} Riders',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.domainCycling),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            activeGroup!.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '📍 Muster: ${activeGroup!.musterPoint}',
            style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          Text(
            '👤 Leader: ${activeGroup!.leaderName} (${activeGroup!.leaderPhone})',
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onOpenHubTap,
                child: const Row(
                  children: [
                    Text(
                      'Open Group Chat & Roster',
                      style: TextStyle(fontSize: 11, color: AppColors.domainCycling, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.chevron_right, size: 14, color: AppColors.domainCycling),
                  ],
                ),
              ),
              TextButton(
                onPressed: onChangeGroupTap,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const Text('Change Active Group', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
