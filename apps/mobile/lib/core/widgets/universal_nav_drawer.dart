import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/domain_models.dart';
import '../services/mock_data_service.dart';

/// Screen 3: Universal Navigation Drawer & Multi-Tenant Event Domain Switcher
/// Featuring Dual Theme (Light/Dark Mode), authentic Nagpur Landmark Cards, and Zero Overflow.
class UniversalNavDrawer extends StatelessWidget {
  const UniversalNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgSurface = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final currentDomain = service.currentDomain;
        return Drawer(
          backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
          child: Column(
            children: [
              // 1. Drawer Header (Multi-Tenant Domain Header, User Info & Theme Toggle)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 18, left: 18, right: 18),
                decoration: BoxDecoration(
                  color: bgSurface,
                  border: Border(
                    bottom: BorderSide(
                      color: borderCol,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Domain Badge & Controls Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.royalPurple.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AppColors.royalPurple.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_getDomainIcon(currentDomain.type), style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    currentDomain.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.royalPurple,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.4,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Theme Mode Toggle & Close Button
                        Row(
                          children: [
                            IconButton(
                              tooltip: service.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: bgElevated,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderCol),
                                ),
                                child: Icon(
                                  service.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                                  size: 15,
                                  color: service.isDarkMode ? AppColors.sunnyGold : AppColors.policeBlue,
                                ),
                              ),
                              onPressed: () {
                                service.toggleTheme();
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: textMuted,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // User Identity Row
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.solarOrange, Color(0xFFFF8533)],
                              ),
                            ),
                            child: const Center(
                              child: Text('ZM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
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
                                      'Citizen Commuter',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textCol),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, size: 14, color: AppColors.solarOrange),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Verified Participant • Tap for QR Pass >',
                                  style: TextStyle(fontSize: 11, color: textMuted),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  children: [
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.map_outlined,
                      title: 'Home Dashboard',
                      subtitle: 'Live Route, Checkpoints & Map',
                      accent: AppColors.solarOrange,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.groups_outlined,
                      title: 'My Sub-Groups',
                      subtitle: 'Manage Contingents (${service.joinedSubGroupIds.length}/3)',
                      accent: AppColors.electricCyan,
                      badge: '${service.joinedSubGroupIds.length}/3',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/groups');
                      },
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.qr_code_2_rounded,
                      title: 'My Rally Pass & Links',
                      subtitle: 'QR Pass, Emergency Info & Share',
                      accent: AppColors.solarOrange,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(color: borderCol),
                    const SizedBox(height: 6),

                    // DEMO ROLE SWITCHER
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        '⚡ DEMO ROLE VIEWS',
                        style: TextStyle(color: textMuted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                      ),
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.hub_outlined,
                      title: 'Group Leader Hub',
                      subtitle: 'VNIT Riders • SOS Triage & Roster',
                      accent: AppColors.vibrantEmerald,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/leader');
                      },
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.local_police_outlined,
                      title: 'Traffic Police Command',
                      subtitle: 'Live Road Closures & Corridors',
                      accent: AppColors.policeBlue,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/police');
                      },
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'SuperAdmin Console',
                      subtitle: 'Domain Governance & Live Map',
                      accent: AppColors.sosRed,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin');
                      },
                    ),
                    _navItem(
                      context,
                      isDark: isDark,
                      icon: Icons.developer_mode_outlined,
                      title: 'Developer Panel',
                      subtitle: 'Master DB Reset & Provisioning',
                      accent: AppColors.sunnyGold,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/dev-panel');
                      },
                    ),
                  ],
                ),
              ),

              // 3. Theme Mode Quick Toggle Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          service.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          size: 16,
                          color: service.isDarkMode ? AppColors.popPurple : AppColors.solarOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          service.isDarkMode ? 'Dark Mode Active' : 'Light Mode Active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: textCol,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: service.isDarkMode,
                      activeTrackColor: AppColors.solarOrange,
                      onChanged: (val) => service.setThemeMode(val),
                    ),
                  ],
                ),
              ),

              // 4. Fixed Bottom Button: [ 🔄 SWITCH EVENT DOMAIN ]
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgSurface,
                  border: Border(
                    top: BorderSide(color: borderCol),
                  ),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.sync_rounded, size: 18),
                  label: const Text(
                    '🔄 SWITCH EVENT DOMAIN',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showDomainSwitcherModal(context, service);
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
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? accent,
    String? badge,
  }) {
    final itemColor = accent ?? AppColors.solarOrange;
    final bgSurface = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: itemColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: itemColor, size: 18),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textCol),
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
                  style: TextStyle(color: itemColor, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 10, color: textMuted),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textMuted),
        onTap: onTap,
      ),
    );
  }

  // --- Scrollable, Zero-Overflow Domain Switcher with Nagpur Landmark Imagery ---
  static void _showDomainSwitcherModal(BuildContext context, MockDataService service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgSurface = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textMuted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT ACTIVE EVENT DOMAIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: textCol,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 18, color: textMuted),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  'Switching domains dynamically updates the live route, enrolled sub-groups, and emergency routing.',
                  style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                ),
                const SizedBox(height: 14),

                // Scrollable Domains List
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: service.domains.length,
                    itemBuilder: (context, index) {
                      final domain = service.domains[index];
                      final isSelected = domain.id == service.currentDomain.id;
                      final color = _getDomainColor(domain.type);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? color : borderCol,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? color.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            service.switchDomain(domain);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: color,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                content: Text(
                                  '🔄 Switched domain to ${domain.name}!',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Optional Nagpur Landmark Banner Image
                              if (domain.imageUrl != null)
                                Container(
                                  height: 90,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(domain.imageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.75),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.place_rounded, color: AppColors.sunnyGold, size: 11),
                                          const SizedBox(width: 4),
                                          Text(
                                            domain.landmarkLocation ?? 'Nagpur Landmark',
                                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              // Details Row
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(_getDomainIcon(domain.type), style: const TextStyle(fontSize: 20)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  domain.name,
                                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: textCol),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (isSelected) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: const Text('ACTIVE', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white)),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${domain.routeSummary} • ${domain.status.name.toUpperCase()}',
                                            style: TextStyle(fontSize: 10.5, color: textMuted),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                      color: isSelected ? color : textMuted,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
        return AppColors.solarOrange;
      case DomainType.marathon:
        return AppColors.vibrantEmerald;
      case DomainType.protest:
        return AppColors.domainProtest;
      case DomainType.walkathon:
        return AppColors.electricCyan;
      case DomainType.parade:
        return AppColors.popPurple;
    }
  }
}
