import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Surface Tokens
  static const Color bgPrimaryDark = Color(0xFF090D16);
  static const Color surfaceCardDark = Color(0xFF131B2E);
  static const Color surfaceGlassDark = Color(0xBF131B2E);
  static const Color surfaceHoverDark = Color(0xFF1C2740);
  static const Color borderSubtleDark = Color(0x14FFFFFF);

  // Light Mode Surface Tokens
  static const Color bgPrimaryLight = Color(0xFFF8FAFC);
  static const Color surfaceCardLight = Color(0xFFFFFFFF);
  static const Color surfaceGlassLight = Color(0xF2FFFFFF);
  static const Color surfaceHoverLight = Color(0xFFF1F5F9);
  static const Color borderSubtleLight = Color(0x1E000000);

  // Multi-Domain Accent Colors
  static const Color domainCycling = Color(0xFF00F2FE);    // 🚲 Cycling (Cyan)
  static const Color domainMarathon = Color(0xFF00E676);   // 🏃 Marathon (Emerald)
  static const Color domainProtest = Color(0xFFFF9100);    // 📢 Protest Rally (Amber)
  static const Color domainParade = Color(0xFFD500F9);     // 🎪 Parade & Procession (Purple)
  static const Color domainWalkathon = Color(0xFF00B0FF);  // 🚶 Walkathon (Sky Blue)

  // System & Emergency Accents
  static const Color sosRed = Color(0xFFFF1744);
  static const Color sosRedGlass = Color(0x33FF1744);
  static const Color policeBlue = Color(0xFF2979FF);
  static const Color successGreen = Color(0xFF00E676);
  static const Color warningAmber = Color(0xFFFFC107);

  // Text Tokens (Dark)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Text Tokens (Light)
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Backwards-compatible aliases
  static const Color bgPrimary = bgPrimaryDark;
  static const Color surfaceCard = surfaceCardDark;
  static const Color surfaceGlass = surfaceGlassDark;
  static const Color surfaceHover = surfaceHoverDark;
  static const Color borderSubtle = borderSubtleDark;
  static const Color borderHighlight = Color(0x3300F2FE);
  static const Color textPrimary = textPrimaryDark;
  static const Color textSecondary = textSecondaryDark;
  static const Color textMuted = textMutedDark;

  // Dynamic Density Step Shading Colors (Matching PROJECT_PLAN.md)
  static const Color densitySparse = Color(0xFF51BBD6);    // 1-25 pax (Cyan)
  static const Color densityModerate = Color(0xFF3BB2D0);  // 25-100 pax (Sky Blue)
  static const Color densityHigh = Color(0xFFF1F075);      // 100-300 pax (Amber)
  static const Color densityVeryHigh = Color(0xFFE55E5E);  // 300-600 pax (Coral)
  static const Color densityExtreme = Color(0xFF7B1FA2);   // 600+ pax (Purple)

  static Color getDensityColor(int count) {
    if (count <= 25) return densitySparse;
    if (count <= 100) return densityModerate;
    if (count <= 300) return densityHigh;
    if (count <= 600) return densityVeryHigh;
    return densityExtreme;
  }
}
