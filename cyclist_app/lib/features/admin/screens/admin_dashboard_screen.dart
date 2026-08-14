import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// Page 5: Event Admin & Route Creator Studio (HERO SCREEN 2)
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Event Admin Studio', style: AppTypography.h3),
        backgroundColor: AppColors.surfaceCard,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Route Editor Canvas
          Container(
            color: const Color(0xFF0F172A),
            child: const Center(
              child: Text('Interactive Route Painter & Checkpoint Tool', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          // Active SOS Emergency Alert Triage Card (Bottom)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: GlassCard(
              customBorder: Border.all(color: AppColors.sosRed, width: 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🚨 ACTIVE SOS EMERGENCY ALERT', style: TextStyle(color: AppColors.sosRed, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('2 mins ago', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Rahul Sharma (Bib #142) • Near High Court Chowk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: AppColors.borderSubtle)),
                          icon: const Icon(Icons.call, size: 16, color: AppColors.cyanElectric),
                          label: const Text('Call'),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldNeon, foregroundColor: Colors.black),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Resolve', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
