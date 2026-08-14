import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/domain_models.dart';
import '../services/mock_data_service.dart';

/// Screen 3: Universal Navigation Drawer & Multi-Tenant Event Domain Switcher
/// Strictly adhering to PROJECT_PLAN.md Section 2 (Screen 3)
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
          child: Column(
            children: [
              // 1. Drawer Header (Multi-Tenant Domain Header & User Info)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Domain Badge & Close Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDomainColor(currentDomain.type).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getDomainColor(currentDomain.type).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_getDomainIcon(currentDomain.type), style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 6),
                              Text(
                                currentDomain.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: _getDomainColor(currentDomain.type),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // User Identity Row
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.domainCycling,
                            child: const Text('RS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, size: 14, color: AppColors.domainCycling),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '+91 98230-12345 • Tap for Pass >',
                                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Navigation Links List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  children: [
                    _navItem(
                      context,
                      icon: Icons.map_outlined,
                      title: 'Home Dashboard',
                      subtitle: 'Live Route, Checkpoints & Map',
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    _navItem(
                      context,
                      icon: Icons.groups_outlined,
                      title: 'My Sub-Groups',
                      subtitle: 'Manage Contingents (${service.joinedSubGroupIds.length}/3)',
                      isDark: isDark,
                      badge: '${service.joinedSubGroupIds.length}/3',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/groups');
                      },
                    ),
                    _navItem(
                      context,
                      icon: Icons.qr_code_2_rounded,
                      title: 'My Rally Pass & Links',
                      subtitle: 'QR Pass, Emergency Info & Share',
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),

                    const SizedBox(height: 12),
                    Divider(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                    const SizedBox(height: 8),

                    // DEMO ROLE SWITCHER
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'DEMO ROLE VIEWS:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    _navItem(
                      context,
                      icon: Icons.hub_outlined,
                      title: 'Group Leader Hub',
                      subtitle: 'VNIT Riders • SOS Triage & Roster',
                      isDark: isDark,
                      accent: AppColors.domainMarathon,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/leader');
                      },
                    ),
                    _navItem(
                      context,
                      icon: Icons.local_police_outlined,
                      title: 'Traffic Police Command',
                      subtitle: 'Live Road Closures & Corridors',
                      isDark: isDark,
                      accent: AppColors.policeBlue,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/police');
                      },
                    ),
                    _navItem(
                      context,
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'SuperAdmin Console',
                      subtitle: 'Domain Governance & Live Map',
                      isDark: isDark,
                      accent: AppColors.sosRed,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin');
                      },
                    ),
                    _navItem(
                      context,
                      icon: Icons.developer_mode_outlined,
                      title: 'Developer Panel',
                      subtitle: 'Master DB Reset & Provisioning',
                      isDark: isDark,
                      accent: AppColors.domainProtest,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/dev-panel');
                      },
                    ),
                  ],
                ),
              ),

              // 3. Discreet Group Creation Footer Link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/request-group');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Have an org, club, or union?',
                              style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
                            ),
                            Text(
                              '[ 📋 Request to create a group > ]',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.domainCycling : const Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: isDark ? AppColors.domainCycling : const Color(0xFF0284C7)),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Fixed Bottom Button: [ 🔄 SWITCH EVENT DOMAIN ]
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                    ),
                  ),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.domainCycling,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.sync_rounded, size: 18),
                  label: const Text(
                    '🔄 SWITCH EVENT DOMAIN',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showDomainSwitcherModal(context, service, isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Color? accent,
    String? badge,
  }) {
    final itemColor = accent ?? (isDark ? AppColors.domainCycling : const Color(0xFF0284C7));

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: itemColor, size: 20),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: itemColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: itemColor),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: isDark ? Colors.white38 : Colors.black38),
        onTap: onTap,
      ),
    );
  }

  static void _showDomainSwitcherModal(BuildContext context, MockDataService service, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.bgPrimaryDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SELECT ACTIVE EVENT DOMAIN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Switching domains changes the live route, enrolled sub-groups, and emergency routing context.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...service.domains.map((domain) {
                final isSelected = domain.id == service.currentDomain.id;
                final color = _getDomainColor(domain.type);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: isDark ? 0.15 : 0.1)
                        : (isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? color : (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_getDomainIcon(domain.type), style: const TextStyle(fontSize: 18)),
                    ),
                    title: Row(
                      children: [
                        Text(
                          domain.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('ACTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      '${domain.routeSummary} • ${domain.status.name.toUpperCase()}',
                      style: TextStyle(fontSize: 10, color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: color, size: 20)
                        : const Icon(Icons.radio_button_unchecked, size: 18, color: AppColors.textMuted),
                    onTap: () {
                      service.switchDomain(domain.id);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: color,
                          content: Text(
                            '🔄 Switched domain to ${domain.name}!',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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

  static String _getDomainIcon(DomainType type) {
    switch (type) {
      case DomainType.cycling:
        return '🚲';
      case DomainType.marathon:
        return '🏃';
      case DomainType.protest:
        return '📢';
      case DomainType.walkathon:
        return '🚶';
      case DomainType.parade:
        return '🎺';
    }
  }

  static Color _getDomainColor(DomainType type) {
    switch (type) {
      case DomainType.cycling:
        return AppColors.domainCycling;
      case DomainType.marathon:
        return AppColors.domainMarathon;
      case DomainType.protest:
        return AppColors.domainProtest;
      case DomainType.walkathon:
        return AppColors.domainWalkathon;
      case DomainType.parade:
        return AppColors.domainParade;
    }
  }
}
