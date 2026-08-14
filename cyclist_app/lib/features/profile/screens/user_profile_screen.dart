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

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final isDark = service.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimaryLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgPrimaryDark : AppColors.surfaceCardLight,
            title: const Text('PARTICIPANT PROFILE & PASS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LinkSharingModal(),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Profile Avatar & Contact Card
              GlassCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF1E293B),
                      child: Text('RS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.domainCycling)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rajesh Sharma', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('📱 +91 98230-12345', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('🆘 Next-of-Kin: +91 98230-99999 (Mom)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          Text('🩸 Blood Group: O+ Positive', style: TextStyle(fontSize: 11, color: AppColors.domainCycling)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Official Rally QR Pass Card
              GlassCard(
                borderColor: AppColors.domainCycling.withOpacity(0.4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.qr_code_2_rounded, color: AppColors.domainCycling, size: 20),
                            SizedBox(width: 8),
                            Text('OFFICIAL RALLY PASS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.domainCycling)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.domainMarathon.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('VERIFIED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainMarathon)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // QR Canvas Placeholder with Clean Grid
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code_rounded, size: 140, color: Colors.black),
                          const SizedBox(height: 6),
                          const Text(
                            'NAGPUR-2026-RS-8891',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Present this QR at Muster Points & Finish Pavilion', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. Link Sharing Action Card
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.link_rounded, color: AppColors.domainCycling, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Share Live Tracking Links', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Send encrypted tracking URL to family & friends.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
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
                        showDialog(
                          context: context,
                          builder: (context) => const LinkSharingModal(),
                        );
                      },
                      child: const Text('Share Links', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 4. App Theme Mode Toggle (Dark / Light Mode)
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.warningAmber, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isDark ? 'Dark Mode (Active)' : 'Light Mode (Active)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text('Toggle high-contrast theme', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      activeColor: AppColors.domainCycling,
                      onChanged: (val) => service.toggleTheme(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
