import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/domain_models.dart';
import '../services/mock_data_service.dart';

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
                // Domain Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                    border: Border(bottom: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.domainCycling.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.directions_bike, color: AppColors.domainCycling, size: 20),
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
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              currentDomain.type.name.toUpperCase(),
                              style: const TextStyle(fontSize: 10, color: AppColors.domainCycling, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // User Profile Quick Info
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF1E293B),
                          child: Text('RS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rajesh Sharma',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                              ),
                              const Text('+91 98230-12345 • View Profile', style: TextStyle(fontSize: 11, color: AppColors.domainCycling)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),

                Divider(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight, height: 1),

                // Core Navigation Links
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _navTile(
                        icon: Icons.home_rounded,
                        title: 'Home Dashboard',
                        subtitle: 'Rally map & active feeds',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                      _navTile(
                        icon: Icons.groups_rounded,
                        title: 'My Sub-Groups (2/3)',
                        subtitle: 'Contingents & active muster',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/groups');
                        },
                      ),
                      _navTile(
                        icon: Icons.qr_code_rounded,
                        title: 'My Rally Pass & Links',
                        subtitle: 'QR Pass & encrypted sharing',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('ROLE SWITCHER (DEMO)', style: TextStyle(fontSize: 10, color: AppColors.textMuted, letterSpacing: 1)),
                      ),
                      _navTile(
                        icon: Icons.military_tech_rounded,
                        title: '👔 Group Leader Hub',
                        subtitle: 'VNIT Club team operations',
                        accentColor: AppColors.domainMarathon,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/leader');
                        },
                      ),
                      _navTile(
                        icon: Icons.local_police_rounded,
                        title: '👮 Traffic Police Command',
                        subtitle: 'Junction ETAs & road advisories',
                        accentColor: AppColors.policeBlue,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/police');
                        },
                      ),
                      _navTile(
                        icon: Icons.admin_panel_settings_rounded,
                        title: '🛡️ SuperAdmin Console',
                        subtitle: 'Domain governance & dispatch',
                        accentColor: AppColors.domainProtest,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/admin');
                        },
                      ),
                      _navTile(
                        icon: Icons.developer_mode_rounded,
                        title: '🛠️ Developer Master Panel',
                        subtitle: 'SuperAdmin seating & global health',
                        accentColor: AppColors.domainParade,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/dev-panel');
                        },
                      ),
                    ],
                  ),
                ),

                // Discreet Footer Section (Group Application Link)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    border: Border(top: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Have an organization or team?',
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
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.domainCycling),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 14, color: AppColors.domainCycling),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Universal Domain Switcher Button (Fixed at very bottom)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
                      foregroundColor: AppColors.domainCycling,
                      side: const BorderSide(color: AppColors.domainCycling, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.sync_alt_rounded, size: 18),
                    label: const Text(
                      '🔄 SWITCH EVENT DOMAIN',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
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

  static Widget _navTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: accentColor ?? AppColors.textSecondary, size: 22),
      title: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: accentColor ?? Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  static void _showDomainSwitcherModal(BuildContext context, MockDataService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPrimaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Event Domain (Tenant)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(icon: const Icon(Icons.close, color: AppColors.textSecondary), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Each domain isolates all rosters, leaders, routes, and emergency queues.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...service.domains.map((domain) {
                final isSelected = domain.id == service.currentDomain.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceHoverDark : AppColors.surfaceCardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.domainCycling : AppColors.borderSubtleDark,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      domain.type == DomainType.cycling
                          ? Icons.directions_bike
                          : domain.type == DomainType.marathon
                              ? Icons.directions_run
                              : domain.type == DomainType.protest
                                  ? Icons.campaign
                                  : Icons.directions_walk,
                      color: isSelected ? AppColors.domainCycling : AppColors.textSecondary,
                    ),
                    title: Text(domain.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    subtitle: Text(
                      '${domain.status.name.toUpperCase()} • ${domain.routeSummary}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.domainCycling, size: 18) : null,
                    onTap: () {
                      service.switchDomain(domain);
                      Navigator.pop(context);
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
}
