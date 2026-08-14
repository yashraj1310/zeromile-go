import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/domain_models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

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

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          appBar: AppBar(
            backgroundColor: AppColors.bgPrimary,
            title: Text(
              'MY SUB-GROUPS (${enrolledGroups.length}/3 Enrolled)',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner explaining 1 Active Group constraint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.domainCycling),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You can enroll in up to 3 sub-groups, but exactly 1 must be ACTIVE for live GPS muster and SOS escalation.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text('YOUR ENROLLED SUB-GROUPS:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                const SizedBox(height: 8),

                if (enrolledGroups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('No sub-groups enrolled yet.', style: TextStyle(color: AppColors.textMuted))),
                  )
                else
                  ...enrolledGroups.map((group) {
                    final isActive = group.id == activeId;
                    return GlassCard(
                      borderColor: isActive ? AppColors.domainCycling : AppColors.borderSubtle,
                      backgroundColor: isActive ? const Color(0x2E00F2FE) : AppColors.surfaceCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: isActive ? AppColors.domainCycling : AppColors.textMuted,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isActive ? 'CURRENTLY ACTIVE GROUP' : 'INACTIVE FOR TODAY',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isActive ? AppColors.domainCycling : AppColors.textMuted,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isActive)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.surfaceHover,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  ),
                                  onPressed: () => service.setActiveGroup(group.id),
                                  child: const Text('👉 Set Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(group.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Leader: ${group.leaderName} (${group.leaderPhone})', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text('Muster Point: ${group.musterPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${group.memberCount} Members Enrolled', style: const TextStyle(fontSize: 11, color: AppColors.domainCycling)),
                              TextButton(
                                onPressed: () => service.leaveSubGroup(group.id),
                                child: const Text('Exit Group', style: TextStyle(fontSize: 11, color: AppColors.sosRed)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 20),

                // Available Groups to Join (if under limit)
                if (enrolledGroups.length < 3) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('AVAILABLE SUB-GROUPS (${3 - enrolledGroups.length} SLOTS LEFT):', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (availableGroups.isEmpty)
                    const Text('No other public groups available right now.', style: TextStyle(fontSize: 11, color: AppColors.textMuted))
                  else
                    ...availableGroups.map((group) => GlassCard(
                          child: Row(
                            children: [
                              const Icon(Icons.group_add_rounded, color: AppColors.domainCycling, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(group.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('${group.memberCount} Members • Muster: ${group.musterPoint}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.domainCycling,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () {
                                  service.joinSubGroup(group.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Joined ${group.name}!')),
                                  );
                                },
                                child: const Text('Join', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )),
                ],

                const SizedBox(height: 24),

                // Link to apply for new group
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_business_rounded, color: AppColors.domainCycling, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Want to lead your own contingent?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Submit an organization group application for SuperAdmin review.', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceCard,
                          foregroundColor: AppColors.domainCycling,
                          side: const BorderSide(color: AppColors.domainCycling),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/request-group'),
                        child: const Text('Apply', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
