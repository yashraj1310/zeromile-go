import 'package:flutter/material.dart';

class AppColors {
  // --- Vibrant Harmonious Accent Palette (Blue, Green, Purple, Orange) ---
  static const Color royalBlue = Color(0xFF2563EB);         // 🔷 Electric Royal Blue — Command, Traffic, Navigation
  static const Color royalBlueDark = Color(0xFF1D4ED8);     // Deep Sapphire Blue
  static const Color royalBlueSoft = Color(0xFFDBEAFE);     // Soft Ice Blue Pill BG

  static const Color emeraldGreen = Color(0xFF059669);      // ❇️ Lush Emerald Green — Verified, Checkpoints, Safety
  static const Color vibrantEmerald = Color(0xFF10B981);    // Bright Mint Emerald
  static const Color emeraldGreenSoft = Color(0xFFD1FAE5);  // Soft Emerald Tint

  static const Color royalPurple = Color(0xFF7C3AED);       // 🔮 Royal Purple — Governance, VIP Pass, NGOs
  static const Color lavenderPurple = Color(0xFF8B5CF6);    // Bright Purple Accent
  static const Color popPurple = Color(0xFFB8A9E8);         // Soft Lavender
  static const Color royalPurpleSoft = Color(0xFFEDE9FE);   // Soft Lilac Tint

  static const Color solarOrange = Color(0xFFFF5500);       // 🔥 Bold Solar Orange — Brand Core, Active States
  static const Color sunnyGold = Color(0xFFFF9F43);         // ☀️ Warm Amber Gold — Broadcasts, Warnings
  static const Color electricLime = Color(0xFFC6F135);      // ⚡ Lime Indicator
  static const Color popLime = Color(0xFFD4FF00);           // High-Voltage Lime
  static const Color popPink = Color(0xFFFF6B8A);           // Coral Pink
  static const Color electricCyan = Color(0xFF06B6D4);      // Aqua Cyan

  // --- Dark Theme Surfaces ---
  static const Color bgPrimaryDark = Color(0xFF0D0D0D);        // Near-Black Base
  static const Color surfaceCardDark = Color(0xFF1A1A2E);      // Deep Navy-Charcoal Card
  static const Color surfaceGlassDark = Color(0xD91A1A2E);     // Translucent Card
  static const Color surfaceElevatedDark = Color(0xFF232340);  // Dark Indigo Elevated
  static const Color surfaceHoverDark = Color(0xFF2E2E50);     // Hover State
  static const Color borderSubtleDark = Color(0x2AFFFFFF);     // Subtle White Border
  static const Color borderHighlightDark = Color(0x662563EB);  // Blue Highlight Border
  static const Color textPrimaryDark = Color(0xFFF5F5F5);      // Off-White
  static const Color textSecondaryDark = Color(0xFF94A3B8);     // Cool Gray
  static const Color textMutedDark = Color(0xFF64748B);         // Slate Gray

  // --- Crisp Light Theme Surfaces ---
  static const Color bgPrimaryLight = Color(0xFFF6F8FA);        // Clean Off-White Slate Base
  static const Color surfaceCardLight = Color(0xFFFFFFFF);      // Pure White Card
  static const Color surfaceGlassLight = Color(0xF2FFFFFF);     // Frosted White Glass
  static const Color surfaceElevatedLight = Color(0xFFEFF2F6);  // Crisp Light Gray Elevated
  static const Color surfaceHoverLight = Color(0xFFE2E8F0);     // Hover State
  static const Color borderSubtleLight = Color(0x1F0F172A);     // Subtle Slate Border
  static const Color borderHighlightLight = Color(0x662563EB);  // Blue Highlight Border
  static const Color textPrimaryLight = Color(0xFF0F172A);      // Deep Slate Charcoal
  static const Color textSecondaryLight = Color(0xFF475569);    // Cool Gray
  static const Color textMutedLight = Color(0xFF94A3B8);        // Slate Muted Gray

  // --- Fallback Aliases (Dark mode default) ---
  static const Color bgPrimary = bgPrimaryDark;
  static const Color surfaceCard = surfaceCardDark;
  static const Color surfaceGlass = surfaceGlassDark;
  static const Color surfaceElevated = surfaceElevatedDark;
  static const Color surfaceHover = surfaceHoverDark;
  static const Color borderSubtle = borderSubtleDark;
  static const Color borderHighlight = borderHighlightDark;
  static const Color textPrimary = textPrimaryDark;
  static const Color textSecondary = textSecondaryDark;
  static const Color textMuted = textMutedDark;

  // --- Multi-Domain Semantic Accents ---
  static const Color domainCycling = Color(0xFFFF5500);        // 🚲 Cycling (Solar Orange)
  static const Color domainCyclingLight = Color(0xFFFF5500);
  static const Color domainMarathon = Color(0xFF059669);       // 🏃 Marathon (Emerald Green)
  static const Color domainMarathonLight = Color(0xFF059669);
  static const Color domainProtest = Color(0xFFFFB703);        // 📢 Protest Rally (Sunny Gold)
  static const Color domainProtestLight = Color(0xFFD97706);
  static const Color domainParade = Color(0xFF7C3AED);         // 🎪 Civic Rally (Royal Purple)
  static const Color domainWalkathon = Color(0xFF2563EB);      // 🚶 Walkathon (Royal Blue)

  // --- System & Emergency Accents ---
  static const Color sosRed = Color(0xFFFF1744);               // 🚨 Critical Emergency Crimson
  static const Color sosRedGlass = Color(0x29FF1744);
  static const Color policeBlue = Color(0xFF2563EB);           // 👮 Command Blue
  static const Color policeBlueLight = Color(0xFF1D4ED8);
  static const Color successGreen = Color(0xFF059669);
  static const Color warningAmber = Color(0xFFFF9F43);

  // --- Backward-compatible accent aliases ---
  static const Color stravaOrange = solarOrange;
  static const Color athleticEmerald = vibrantEmerald;
  static const Color athleticAmber = sunnyGold;
  static const Color athleticCyan = electricCyan;
  static const Color athleticCoral = popPink;
  static const Color athleticPurple = royalPurple;

  // --- Dynamic Density Step Shading Colors ---
  static const Color densitySparse = Color(0xFF2563EB);        // 1-25 pax (Blue)
  static const Color densityModerate = Color(0xFF059669);      // 25-100 pax (Emerald)
  static const Color densityHigh = Color(0xFFFF9F43);          // 100-300 pax (Amber)
  static const Color densityVeryHigh = Color(0xFFFF6600);      // 300-500 pax (Orange)
  static const Color densityCongested = Color(0xFFFF1744);     // 500+ pax (Crimson)
  static const Color densityExtreme = Color(0xFFFF1744);       // Extreme Crimson
}
