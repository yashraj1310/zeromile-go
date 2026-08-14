import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';

class LinkSharingModal extends StatelessWidget {
  const LinkSharingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = service.themeMode == ThemeMode.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.domainCycling, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.domainCycling.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share_rounded, color: AppColors.domainCycling, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'SHARE LIVE TRACKING LINKS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your encrypted live rally pass or public spectator links with friends, family, and team members.',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
            ),
            const SizedBox(height: 16),

            _shareLinkTile(
              context,
              icon: Icons.qr_code_2_rounded,
              title: 'My Live Rally Pass Link',
              url: 'https://vikasitnagpur.in/pass/NAGPUR-2026-RS-8891',
              accent: AppColors.domainCycling,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _shareLinkTile(
              context,
              icon: Icons.groups_rounded,
              title: 'VNIT Team Live Tracking Link',
              url: 'https://vikasitnagpur.in/team/vnit-riders-2026',
              accent: AppColors.domainMarathon,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _shareLinkTile(
              context,
              icon: Icons.public_rounded,
              title: 'Public Spectator Web Map',
              url: 'https://vikasitnagpur.in/live/cycling-2026',
              accent: AppColors.policeBlue,
              isDark: isDark,
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
    required Color accent,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: accent, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: accent,
                      content: Text(
                        '📋 Copied $title to clipboard!',
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded, size: 12, color: accent),
                      const SizedBox(width: 4),
                      Text(
                        'Copy',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            url,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: isDark ? AppColors.textMuted : AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
