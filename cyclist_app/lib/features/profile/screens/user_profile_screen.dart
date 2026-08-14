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
            title: Text(
              'PARTICIPANT PROFILE & PASS',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share_rounded, color: isDark ? Colors.white : AppColors.textPrimaryLight),
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
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Profile Avatar & Contact Card
              GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1E293B),
                      ),
                      child: const Center(
                        child: Text(
                          'RS',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.domainCycling),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rajesh Sharma',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                          ),
                          const SizedBox(height: 2),
                          const Text('📱 +91 98230-12345', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const Text('🆘 Next-of-Kin: +91 98230-99999 (Mom)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          const Text('🩸 Blood Group: O+ Positive', style: TextStyle(fontSize: 11, color: AppColors.domainCycling, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Official Rally QR Pass Card
              GlassCard(
                borderColor: AppColors.domainCycling.withValues(alpha: 0.4),
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
                            color: AppColors.domainMarathon.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('VERIFIED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.domainMarathon)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // QR Visual Canvas
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.domainCycling.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
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
                          const SizedBox(height: 8),
                          const Text(
                            'NAGPUR-2026-RS-8891',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'monospace',
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Scan at Muster Check-In Point & Finish Pavilion',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.domainCycling,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Share Pass & Tracking Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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

              const SizedBox(height: 14),

              // 3. Dual Theme Switcher (Dark / Light Mode)
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: AppColors.domainCycling,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDark ? 'Dark Theme (Night Mode)' : 'Light Theme (Day Mode)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              isDark ? 'High contrast neon on deep navy' : 'Crisp high-readability slate',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      activeTrackColor: AppColors.domainCycling,
                      onChanged: (val) {
                        service.toggleTheme();
                      },
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
