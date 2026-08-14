import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimaryDark,
      primaryColor: AppColors.domainCycling,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.domainCycling,
        secondary: AppColors.domainMarathon,
        surface: AppColors.surfaceCardDark,
        error: AppColors.sosRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtleDark, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardDark,
        selectedItemColor: AppColors.domainCycling,
        unselectedItemColor: AppColors.textMutedDark,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgPrimaryLight,
      primaryColor: const Color(0xFF0284C7),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0284C7),
        secondary: Color(0xFF059669),
        surface: AppColors.surfaceCardLight,
        error: AppColors.sosRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceCardLight,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCardLight,
        elevation: 2,
        shadowColor: const Color(0x0F000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtleLight, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardLight,
        selectedItemColor: Color(0xFF0284C7),
        unselectedItemColor: AppColors.textMutedLight,
      ),
    );
  }
}
