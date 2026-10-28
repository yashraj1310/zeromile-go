import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/link_sharing_modal.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
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
            title: Text(
              'RALLY PASS & IDENTITY',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14.5,
                letterSpacing: 0.4,
                color: textCol,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share_rounded, color: textCol),
                tooltip: 'Share Pass & Tracking Links',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LinkSharingModal(),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // 1. Profile Avatar & Contact Card
                  GlassCard(
                    borderColor: AppColors.royalPurple.withValues(alpha: 0.35),
                    child: Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.royalBlue, AppColors.royalPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.royalPurple.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'ZM',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Citizen Commuter',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textCol),
                              ),
                              const SizedBox(height: 2),
                              Text('📱 Verified Commuter Profile', style: TextStyle(fontSize: 12, color: textMuted)),
                              Text('🆘 Emergency Kin: Configured', style: TextStyle(fontSize: 12, color: textMuted)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.royalPurple.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '🩸 Blood Group: O+ Positive',
                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.royalPurple),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Dual Theme Engine Switcher Card
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (service.isDarkMode ? AppColors.royalPurple : AppColors.royalBlue).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                service.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                                color: service.isDarkMode ? AppColors.royalPurple : AppColors.royalBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visual Theme Mode',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textCol),
                                ),
                                Text(
                                  service.isDarkMode ? 'Dark Mode (Nagpur Midnight)' : 'Light Mode (Nagpur Day)',
                                  style: TextStyle(fontSize: 11, color: textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: service.isDarkMode,
                          activeTrackColor: AppColors.royalPurple,
                          onChanged: (val) => service.setThemeMode(val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Official Rally QR Pass Card with Nagpur Heritage Badge
                  GlassCard(
                    borderColor: AppColors.royalPurple.withValues(alpha: 0.4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.qr_code_2_rounded, color: AppColors.royalPurple, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'OFFICIAL CITIZEN RALLY PASS',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: textCol,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.vibrantEmerald.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'VERIFIED 2026',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.vibrantEmerald),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // QR Visual Canvas
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.royalPurple.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                color: Colors.black,
                                padding: const EdgeInsets.all(8),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                  ),
                                  itemCount: 25,
                                  itemBuilder: (context, index) {
                                    final isWhite = (index % 2 == 0 || index % 3 == 0);
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: isWhite ? Colors.white : Colors.black,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'PASS #NGP-CYC-2026-8821',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Contingent: VNIT Cycling Club • Sector A (Zero Mile)',
                          style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.royalBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text(
                      'SHARE MY TRACKING PASS LINK',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LinkSharingModal(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
