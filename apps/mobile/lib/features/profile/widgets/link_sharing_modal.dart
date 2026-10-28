import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class LinkSharingModal extends StatelessWidget {
  const LinkSharingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final borderCol = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;
    final bgElevated = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.royalPurple.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.royalPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.share_rounded, color: AppColors.royalPurple, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'SHARE PASS & TRACKING LINKS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: textCol,
                        letterSpacing: 0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Share your verified rally identity pass or public spectator links with family, marshals, and team members.',
                style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
              ),
              const SizedBox(height: 16),

              _shareLinkTile(
                context,
                icon: Icons.qr_code_2_rounded,
                title: 'Official Citizen Rally Pass',
                url: 'https://vikasitnagpur.in/pass/NAGPUR-2026-YS-8891',
                accent: AppColors.solarOrange,
                bgElevated: bgElevated,
                borderCol: borderCol,
                textCol: textCol,
                textMuted: textMuted,
              ),
              const SizedBox(height: 10),

              _shareLinkTile(
                context,
                icon: Icons.groups_rounded,
                title: 'VNIT Contingent Live Map',
                url: 'https://vikasitnagpur.in/team/vnit-riders-2026',
                accent: AppColors.emeraldGreen,
                bgElevated: bgElevated,
                borderCol: borderCol,
                textCol: textCol,
                textMuted: textMuted,
              ),
              const SizedBox(height: 10),

              _shareLinkTile(
                context,
                icon: Icons.public_rounded,
                title: 'Public Spectator Web Feed',
                url: 'https://vikasitnagpur.in/live/nagpur-cycling-2026',
                accent: AppColors.royalBlue,
                bgElevated: bgElevated,
                borderCol: borderCol,
                textCol: textCol,
                textMuted: textMuted,
              ),
              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('DONE / CLOSE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ],
          ),
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
    required Color bgElevated,
    required Color borderCol,
    required Color textCol,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textCol),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  url,
                  style: TextStyle(fontSize: 10, color: textMuted, fontFamily: 'monospace'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: Icon(Icons.copy_rounded, size: 16, color: accent),
            tooltip: 'Copy Link',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.royalPurple,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  content: Text('✓ Copied $title link to clipboard!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
