import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

/// Floating Animated Red SOS Button with multi-ring breathing pulse
class SosButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const SosButton({
    super.key,
    required this.onTap,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.sosRed,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.sosRed.withOpacity(0.4),
              blurRadius: 18,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emergency_outlined, color: Colors.white, size: 24),
              SizedBox(height: 2),
              Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scaleXY(begin: 0.95, end: 1.05, duration: 1200.ms),
    );
  }
}
