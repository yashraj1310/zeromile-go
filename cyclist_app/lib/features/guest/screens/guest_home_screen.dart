import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/live_badge.dart';
import '../../../core/widgets/parallax_tilt.dart';

/// Page 2: Public Guest Home Screen with Blurred Nagpur City Backdrop
class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  int _selectedModeIndex = 0;
  final List<Map<String, dynamic>> _modes = [
    {'name': 'Cycling', 'icon': Icons.directions_bike, 'color': AppColors.cyanElectric},
    {'name': 'Marathon', 'icon': Icons.directions_run, 'color': AppColors.emeraldNeon},
    {'name': 'Walkathon', 'icon': Icons.directions_walk, 'color': AppColors.amberNeon},
    {'name': 'Parade', 'icon': Icons.festival, 'color': AppColors.purpleNeon},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Ambient Stylized Map Background Representation
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.2, -0.4),
                  radius: 1.2,
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF090D16),
                  ],
                ),
              ),
            ),
          ),
          // Frosted Glass Blur Filter
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: AppColors.bgDark.withOpacity(0.6)),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('VIKASIT NAGPUR', style: AppTypography.badgeText.copyWith(color: AppColors.cyanElectric)),
                          Text('Live City Events', style: AppTypography.h2),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/auth'),
                        icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),
                // Mode Selector Bar
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _modes.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedModeIndex == index;
                      final mode = _modes[index];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedModeIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? (mode['color'] as Color).withOpacity(0.2) : AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? (mode['color'] as Color) : AppColors.borderSubtle,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(mode['icon'] as IconData, size: 18, color: isSelected ? mode['color'] as Color : AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                mode['name'] as String,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Active Events List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ParallaxTiltContainer(
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  LiveBadge(text: 'LIVE NOW'),
                                  Text('250 Participants', style: TextStyle(color: AppColors.cyanElectric, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Miles N Milers Annual Cyclothon', style: AppTypography.h3),
                              const SizedBox(height: 6),
                              Text('Route: Futala Lake → Law College Chowk → Seminary Hills', style: AppTypography.bodyMedium),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.cyanElectric,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => Navigator.pushNamed(context, '/participant'),
                                  child: const Text('View Live Telemetry Map', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
