import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/domain_models.dart';
import '../services/mock_data_service.dart';

/// Screen 3: Universal Navigation Drawer with Multi-Tenant Domain Switcher
/// Strictly adhering to PROJECT_PLAN.md with ultra-elegant glassmorphism.
class UniversalNavDrawer extends StatelessWidget {
  const UniversalNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        final isDark = service.themeMode == ThemeMode.dark;

        return Drawer(
          backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Current Domain Header with Glowing Icon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.domainCycling.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.domainCycling.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          _getDomainIcon(currentDomain.type),
                          color: AppColors.domainCycling,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentDomain.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.domainCycling,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${currentDomain.type.name.toUpperCase()} DOMAIN',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.domainCycling,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // 2. Participant Profile Quick Header
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131B2E) : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.domainCycling, Color(0xFF4FACFE)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.domainCycling.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'RS',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF060911),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Rajesh Sharma',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 14, color: AppColors.domainCycling),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '+91 98230-12345 • View Pass & QR',
                                style: TextStyle(fontSize: 11, color: AppColors.domainCycling, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),

                // 3. Navigation Links List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    children: [
                      _navTile(
                        context,
                        icon: Icons.navigation_rounded,
                        title: 'Home Dashboard',
                        subtitle: 'Rally map & live broadcast alerts',
                        isSelected: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                      _navTile(
                        context,
                        icon: Icons.groups_rounded,
                        title: 'My Sub-Groups',
                        subtitle: '2/3 Enrolled • 1-Active Toggle',
                        badge: '2/3',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/groups');
                        },
                      ),
                      _navTile(
                        context,
                        icon: Icons.qr_code_2_rounded,
                        title: 'My Rally Pass & Links',
                        subtitle: 'Official QR Code & encrypted share URLs',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              'DEMO ROLE SWITCHER',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(child: Divider(color: AppColors.borderSubtleDark, height: 1)),
                          ],
                        ),
                      ),

                      _navTile(
                        context,
                        icon: Icons.military_tech_rounded,
                        title: '👔 Group Leader Hub',
                        subtitle: 'VNIT Club team operations & triage',
                        accentColor: AppColors.domainMarathon,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/leader');
                        },
                      ),
                      _navTile(
                        context,
                        icon: Icons.local_police_rounded,
                        title: '👮 Traffic Police Command',
                        subtitle: 'Junction ETAs & road advisories (No SOS)',
                        accentColor: AppColors.policeBlue,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/police');
                        },
                      ),
                      _navTile(
                        context,
                        icon: Icons.admin_panel_settings_rounded,
                        title: '🛡️ SuperAdmin Console',
                        subtitle: 'Domain governance, route & dispatch',
                        accentColor: AppColors.sosRed,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/admin');
                        },
                      ),
                      _navTile(
                        context,
                        icon: Icons.developer_mode_rounded,
                        title: '🛠️ Developer Master Panel',
                        subtitle: 'SuperAdmin seating (5-6 cap) & health',
                        accentColor: AppColors.domainParade,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/dev-panel');
                        },
                      ),
                    ],
                  ),
                ),

                // 4. Discreet Footer Section (Group Application Form Link)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0D1424) : const Color(0xFFF1F5F9),
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Have an organization, college, or club?',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/request-group');
                        },
                        child: const Row(
                          children: [
                            Text(
                              '📋 Request to create a group',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.domainCycling,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.domainCycling),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 5. Universal Domain Switcher Button (Fixed at Bottom)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                      foregroundColor: AppColors.domainCycling,
                      side: const BorderSide(color: AppColors.domainCycling, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.sync_alt_rounded, size: 18),
                    label: const Text(
                      '🔄 SWITCH EVENT DOMAIN',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.8),
                    ),
                    onPressed: () {
                      _showDomainSwitcherModal(context, service);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? accentColor,
    String? badge,
    bool isSelected = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.domainCycling.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: accentColor ?? (isSelected ? AppColors.domainCycling : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          size: 20,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: accentColor ?? (isSelected ? AppColors.domainCycling : (isDark ? Colors.white : AppColors.textPrimaryLight)),
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.domainCycling.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                ),
              ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }

  static void _showDomainSwitcherModal(BuildContext context, MockDataService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPrimaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Event Domain (Tenant)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Each domain isolates all rosters, routes, broadcasts, and emergency queues.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...service.domains.map((domain) {
                final isSelected = domain.id == service.currentDomain.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E293B) : AppColors.surfaceCardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.domainCycling : AppColors.borderSubtleDark,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _getDomainIcon(domain.type),
                      color: isSelected ? AppColors.domainCycling : AppColors.textSecondaryDark,
                    ),
                    title: Text(
                      domain.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(
                      '${domain.status.name.toUpperCase()} • ${domain.routeSummary}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.domainCycling, size: 20) : null,
                    onTap: () {
                      service.switchDomain(domain);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.domainCycling,
                          content: Text(
                            '🔄 Switched to ${domain.name}!',
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  static IconData _getDomainIcon(DomainType type) {
    switch (type) {
      case DomainType.cycling:
        return Icons.directions_bike_rounded;
      case DomainType.marathon:
        return Icons.directions_run_rounded;
      case DomainType.protest:
        return Icons.campaign_rounded;
      case DomainType.parade:
      case DomainType.walkathon:
        return Icons.directions_walk_rounded;
    }
  }
}
