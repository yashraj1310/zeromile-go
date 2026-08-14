import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Custom Vector Map Markers for Google Maps / flutter_map
class CustomMapMarkers {
  CustomMapMarkers._();

  /// 🚴 Cyclist Rally Head Marker (Cyan pulse pin with directional arrow)
  static Widget buildCyclistMarker() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cyanElectric, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanElectric.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.directions_bike, color: AppColors.cyanElectric, size: 22),
    );
  }

  /// 🏃 Marathon Runner Marker (Emerald shoe / runner badge)
  static Widget buildRunnerMarker() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.emeraldNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldNeon.withOpacity(0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(Icons.directions_run, color: AppColors.emeraldNeon, size: 20),
    );
  }

  /// 💧 Water / Hydration Station Pin
  static Widget buildHydrationMarker() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF0284C7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Icon(Icons.water_drop, color: Colors.white, size: 18),
    );
  }

  /// 👮 Police Traffic Checkpoint Marker
  static Widget buildPoliceMarker() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.policeBlue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Icon(Icons.local_police, color: Colors.white, size: 18),
    );
  }
}
