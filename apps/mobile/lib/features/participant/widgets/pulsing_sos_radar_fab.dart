import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import 'sos_trigger_dialog.dart';

class PulsingSosRadarFab extends StatelessWidget {
  const PulsingSosRadarFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Emergency SOS',
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const SosTriggerDialog(),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 6, right: 4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle Outer Radar Pulse Ring
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sosRed.withValues(alpha: 0.25),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.35, 1.35),
                    duration: 1500.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeOut(duration: 1500.ms),

              // Compact Solid Crimson SOS Button
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF3366),
                      Color(0xFFFF1744),
                      Color(0xFFD50000),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF1744).withValues(alpha: 0.5),
                      blurRadius: 14,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
    );
  }
}
