import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

/// Screen 2: Dedicated Sub-Groups Management Tab (/groups)
/// Strictly adhering to PROJECT_PLAN.md wireframe and business rules:
/// 1. Max 3 Sub-Groups Limit
/// 2. Exactly 1 Active Group Rule for live GPS muster & SOS escalation
class GroupsManagementScreen extends StatelessWidget {
  const GroupsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final enrolledIds = service.joinedSubGroupIds;
        final enrolledGroups = service.subGroups.where((g) => enrolledIds.contains(g.id)).toList();
        final availableGroups = service.subGroups.where((g) => !g.isGeneral && !enrolledIds.contains(g.id)).toList();
        final activeId = service.activeSubGroupId;
        final isDark = service.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : AppColors.textPrimaryLight),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Text(
                  'MY SUB-GROUPS',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.domainCycling.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.domainCycling.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${enrolledGroups.length} / 3 Enrolled',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Explanatory Rule Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.domainCycling),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1-ACTIVE GROUP RULE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Select which sub-group is ACTIVE for today\'s live muster, telemetry tracking, and SOS emergency routing.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Enrolled Sub-Groups List
              Text(
                'YOUR ENROLLED CONTINGENTS (${enrolledGroups.length}/3):',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              if (enrolledGroups.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No sub-groups enrolled yet.', style: TextStyle(color: AppColors.textMuted))),
                )
              else
                ...enrolledGroups.map((group) {
                  final isActive = group.id == activeId;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      borderColor: isActive ? AppColors.domainCycling : (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                      backgroundColor: isActive
                          ? (isDark ? const Color(0x2E00F2FE) : const Color(0x1500F2FE))
                          : (isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isActive ? AppColors.domainMarathon : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                                      size: 12,
                                      color: isActive ? Colors.black : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isActive ? '● CURRENTLY ACTIVE' : '○ INACTIVE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: isActive ? Colors.black : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  group.orgCategory.name.toUpperCase(),
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Group Title
                          Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${group.memberCount} Members • Muster: ${group.musterPoint}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          Text(
                            'Leader: ${group.leaderName} (${group.leaderPhone})',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 6),

                          // Context routing hint
                          Text(
                            isActive
                                ? 'ℹ️ SOS will route directly to: ${group.leaderName} (Leader)'
                                : 'ℹ️ Inactive for today\'s SOS routing & live muster.',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isActive ? AppColors.domainCycling : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Action Buttons
                          if (isActive) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                      foregroundColor: AppColors.domainCycling,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    icon: const Icon(Icons.hub_rounded, size: 16),
                                    label: const Text('Open Group Hub >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/leader');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.domainCycling,
                                      foregroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    onPressed: () {
                                      service.setActiveGroup(group.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.domainCycling,
                                          content: Text(
                                            '👉 Active group switched to ${group.name}!',
                                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('👉 Set as Active Group', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 8),

              // 3. Join / Request 3rd Sub-Group Button
              if (enrolledGroups.length < 3) ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.domainCycling,
                    side: BorderSide(color: AppColors.domainCycling.withValues(alpha: 0.5), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: Text(
                    '[ + Join / Request ${enrolledGroups.length + 1}rd Sub-Group ]',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/request-group');
                  },
                ),
              ],

              const SizedBox(height: 24),

              // 4. Available Public Sub-Groups to Join
              Text(
                'AVAILABLE PUBLIC CONTINGENTS IN NAGPUR:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              ...availableGroups.map((group) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.domainCycling.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.groups_rounded, color: AppColors.domainCycling, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              '${group.memberCount} members • Muster: ${group.musterPoint}',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: enrolledGroups.length >= 3
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColors.sosRed,
                                    content: Text('⚠️ Max 3 Sub-Groups Limit reached per domain!'),
                                  ),
                                );
                              }
                            : () {
                                service.joinSubGroup(group.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.domainCycling,
                                    content: Text(
                                      '✓ Joined ${group.name}!',
                                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                        child: const Text('Join', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
