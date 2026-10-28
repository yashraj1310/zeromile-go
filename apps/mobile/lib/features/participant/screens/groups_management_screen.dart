import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';

/// Screen 2: Dedicated Sub-Groups Management Tab (/groups)
/// Dual-Theme Aware, Responsive Desktop/Mobile Centered Layout, and Rich Contingent Photo Cards.
class GroupsManagementScreen extends StatelessWidget {
  const GroupsManagementScreen({super.key});

  // Photo map for authentic visual identity
  static const Map<String, String> _groupImages = {
    'group-vnit-riders': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=800&q=80',
    'group-orange-city-sprinters': 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=800&q=80',
    'group-dharampeth-riders': 'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=800&q=80',
    'group-sitabuldi-sprint': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=800&q=80',
  };

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final enrolledIds = service.joinedSubGroupIds;
        final enrolledGroups = service.subGroups.where((g) => enrolledIds.contains(g.id)).toList();
        final availableGroups = service.subGroups.where((g) => !g.isGeneral && !enrolledIds.contains(g.id)).toList();
        final activeId = service.activeSubGroupId;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 68,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: textCol),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'MY SUB-GROUPS',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.4,
                      color: textCol,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.royalPurple.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.royalPurple.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    '${enrolledGroups.length} / 3 Enrolled',
                    style: const TextStyle(color: AppColors.royalPurple, fontSize: 9.5, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // 1. Explanatory Rule Banner
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderColor: AppColors.royalPurple.withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.royalPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.shield_outlined, size: 22, color: AppColors.royalPurple),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1-ACTIVE GROUP RULE',
                                style: TextStyle(
                                  color: textCol,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Select your active group for muster assembly, leader check-in, and emergency SOS routing.',
                                style: TextStyle(fontSize: 11.5, color: textMuted, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. Enrolled Sub-Groups List
                  Text(
                    'YOUR ENROLLED CONTINGENTS (${enrolledGroups.length}/3)',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (enrolledGroups.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No sub-groups enrolled yet. Join an open public contingent below!',
                          style: TextStyle(color: textMuted, fontSize: 12),
                        ),
                      ),
                    )
                  else
                    ...enrolledGroups.map((group) {
                      final isActive = group.id == activeId;
                      final imageUrl = _groupImages[group.id] ?? 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=800&q=80';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          borderColor: isActive ? AppColors.solarOrange : borderCol,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Contingent Photo Banner
                              Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.85),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isActive ? AppColors.solarOrange : Colors.black.withValues(alpha: 0.7),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isActive ? Colors.transparent : Colors.white24,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isActive ? Icons.check_circle_rounded : Icons.radio_button_off,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              isActive ? 'CURRENTLY ACTIVE' : 'INACTIVE',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.white24),
                                        ),
                                        child: Text(
                                          group.orgCategory.name.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Card Details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: textCol,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.place_rounded, size: 14, color: AppColors.sunnyGold),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Muster: ${group.musterPoint}',
                                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textCol),
                                          ),
                                        ),
                                        Text(
                                          '👥 ${group.memberCount} Riders',
                                          style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Leader: ${group.leaderName} (${group.leaderPhone})',
                                      style: TextStyle(fontSize: 11, color: textMuted),
                                    ),
                                    const SizedBox(height: 14),

                                    // Action Button Row
                                    if (isActive) ...[
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: bgElevated,
                                            foregroundColor: textCol,
                                            elevation: 0,
                                            side: BorderSide(color: borderCol),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          icon: const Icon(Icons.hub_rounded, size: 16, color: AppColors.solarOrange),
                                          label: const Text(
                                            'Open Group Leader Hub >',
                                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                          ),
                                          onPressed: () => Navigator.pushNamed(context, '/leader'),
                                        ),
                                      ),
                                    ] else ...[
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.solarOrange,
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          onPressed: () {
                                            service.setActiveGroup(group.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor: AppColors.solarOrange,
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                content: Text(
                                                  '✓ Switched active contingent to ${group.name}!',
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Set as Active Contingent',
                                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 8),

                  // 3. Request New Sub-Group Button
                  if (enrolledGroups.length < 3) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.solarOrange,
                        side: const BorderSide(color: AppColors.solarOrange, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                      label: Text(
                        '[ + Request to Form ${enrolledGroups.length + 1}rd Sub-Group ]',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/request-group'),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 4. Available Public Sub-Groups in Nagpur
                  Text(
                    'AVAILABLE PUBLIC CONTINGENTS IN NAGPUR',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...availableGroups.map((group) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: GlassCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.solarOrange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.groups_rounded, color: AppColors.solarOrange, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group.name,
                                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: textCol),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${group.memberCount} members • Muster: ${group.musterPoint}',
                                    style: TextStyle(fontSize: 11, color: textMuted),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.solarOrange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 1,
                              ),
                              onPressed: enrolledGroups.length >= 3
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.sosRed,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          content: const Text('⚠️ Max 3 Sub-Groups Limit reached per domain!'),
                                        ),
                                      );
                                    }
                                  : () {
                                      service.joinSubGroup(group.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.solarOrange,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          content: Text(
                                            '✓ Joined ${group.name}!',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                              child: const Text(
                                'Join',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
