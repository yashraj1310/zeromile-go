import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class LinkSharingModal extends StatelessWidget {
  const LinkSharingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.domainCycling, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.share_rounded, color: AppColors.domainCycling, size: 22),
                SizedBox(width: 10),
                Text(
                  'SHARE LIVE TRACKING LINKS',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your encrypted live rally pass or public spectator links with friends and family.',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            _shareLinkTile(
              context,
              icon: Icons.qr_code_rounded,
              title: 'My Live Rally Pass Link',
              url: 'https://vikasitnagpur.in/pass/NAGPUR-2026-RS-8891',
              accent: AppColors.domainCycling,
            ),
            const SizedBox(height: 10),

            _shareLinkTile(
              context,
              icon: Icons.groups_rounded,
              title: 'VNIT Team Live Tracking Link',
              url: 'https://vikasitnagpur.in/team/vnit-riders-2026',
              accent: AppColors.domainMarathon,
            ),
            const SizedBox(height: 10),

            _shareLinkTile(
              context,
              icon: Icons.public_rounded,
              title: 'Public Spectator Web Map',
              url: 'https://vikasitnagpur.in/live/cycling-2026',
              accent: AppColors.policeBlue,
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceHover,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: accent),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✓ Copied $title to clipboard!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded, size: 12, color: accent),
                      const SizedBox(width: 4),
                      Text('Copy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            url,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
