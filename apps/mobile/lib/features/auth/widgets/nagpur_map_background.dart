import 'dart:ui';
import 'package:flutter/material.dart';

/// Authentic Nagpur District & City Map Background with Frosted Glass Blur
class NagpurMapBackground extends StatelessWidget {
  final bool isDark;
  const NagpurMapBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Authentic Nagpur District Map Image (Uploaded Asset)
        Positioned.fill(
          child: Image.asset(
            'assets/images/nagpur_district_map.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            ),
          ),
        ),

        // 2. High-Contrast Royal Blue & Purple Gradient Overlay Tint
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF0F172A).withValues(alpha: 0.78),
                        const Color(0xFF1E1B4B).withValues(alpha: 0.72), // Deep Indigo / Royal Purple
                        const Color(0xFF172554).withValues(alpha: 0.82), // Deep Royal Blue
                      ]
                    : [
                        const Color(0xFFEFF6FF).withValues(alpha: 0.75), // Light Blue tint
                        const Color(0xFFFAF5FF).withValues(alpha: 0.70), // Light Purple tint
                        Colors.white.withValues(alpha: 0.80),
                      ],
              ),
            ),
          ),
        ),

        // 3. Frosted Glass Blur (Keeping map contours, NH-7, NH-6, and towns visible through glass)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // 4. Subtle Radial Vignette
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    Colors.transparent,
                    (isDark ? Colors.black : const Color(0xFF1E3A8A)).withValues(alpha: isDark ? 0.45 : 0.12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
