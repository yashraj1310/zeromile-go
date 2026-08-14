import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// Page 7: Traffic Police & Civic Authority Dashboard (HERO SCREEN 3)
class PoliceDashboardScreen extends StatelessWidget {
  const PoliceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_police, color: AppColors.policeBlue, size: 22),
            const SizedBox(width: 8),
            Text('Nagpur Traffic Police Command', style: AppTypography.h3),
          ],
        ),
        backgroundColor: AppColors.surfaceCard,
      ),
      body: Stack(
        children: [
          // Multi-event map overlay
          Container(
            color: const Color(0xFF090D16),
            child: const Center(
              child: Text('Multi-Event City-Wide Traffic Flow Overlay', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          // Junction arrival countdown & Advisory composer
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.amberNeon),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Variety Square Chowk Arrival', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('Cyclothon rally head arriving in 8 mins • Expected Slowdown: HIGH', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.policeBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.campaign_outlined),
                    label: const Text('Broadcast Official Police Advisory', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
