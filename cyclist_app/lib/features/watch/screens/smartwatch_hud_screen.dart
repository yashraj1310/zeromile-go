import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Smartwatch HUD Screen (Wear OS & Apple Watch circular layout)
class SmartwatchHudScreen extends StatelessWidget {
  const SmartwatchHudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyanElectric.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SPEED', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
              const Text('24.5', style: TextStyle(color: AppColors.cyanElectric, fontSize: 36, fontWeight: FontWeight.w900)),
              const Text('KM/H', style: TextStyle(color: AppColors.cyanElectric, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // Emergency SOS Dial
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Watch SOS Triggered! Vibrate Phone.')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('HOLD SOS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
