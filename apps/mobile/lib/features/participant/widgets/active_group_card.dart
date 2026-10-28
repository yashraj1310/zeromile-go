import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/domain_models.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    if (activeGroup == null) {
      return GlassCard(
        borderColor: borderCol,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgElevated,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.group_off_rounded,
                color: textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Active Sub-Group',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textCol),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to select or join your cycling contingent.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.solarOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
              ),
              onPressed: onChangeGroupTap,
              child: const Text(
                'Join Group',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      borderColor: AppColors.solarOrange.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.solarOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'YOUR CONTINGENT',
                    style: AppTypography.chipLabel(
                      color: AppColors.solarOrange,
                    ).copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.solarOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.solarOrange.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_bike_rounded, size: 12, color: AppColors.solarOrange),
                    const SizedBox(width: 4),
                    Text(
                      '${activeGroup!.memberCount} Riders Live',
                      style: AppTypography.chipLabel(
                        color: AppColors.solarOrange,
                      ).copyWith(fontWeight: FontWeight.w900, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Group Name
          Text(
            activeGroup!.name,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: textCol),
          ),
          const SizedBox(height: 6),

          // Muster Location Pill
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.sunnyGold),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Muster Point: ${activeGroup!.musterPoint}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textCol,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Leader Details & Distance Telemetry
          Row(
            children: [
              const Icon(Icons.person_pin_circle_rounded, size: 14, color: AppColors.electricCyan),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Leader: ${activeGroup!.leaderName} • Proximity: ~45m ahead',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: borderCol, height: 1),
          const SizedBox(height: 10),

          // Action Shortcuts Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onOpenHubTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.solarOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.chat_bubble_outline_rounded, size: 13, color: AppColors.solarOrange),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Team Hub & Roster',
                        style: AppTypography.chipLabel(
                          color: AppColors.solarOrange,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.solarOrange,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onChangeGroupTap,
                icon: Icon(Icons.swap_horiz_rounded, size: 14, color: textMuted),
                label: Text(
                  'Switch Active',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
