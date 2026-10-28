import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // --- Poppins Headlines (Bold, Rounded, Modern) ---

  static TextStyle heroMetric({Color? color}) => GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: color ?? AppColors.textPrimary,
    letterSpacing: -1.2,
    height: 1.05,
  );

  static TextStyle subMetric({Color? color}) => GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle displayLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle titleLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
  );

  // --- Plus Jakarta Sans Body Text ---

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textSecondary,
    height: 1.45,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textMuted,
    height: 1.35,
  );

  static TextStyle chipLabel({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle buttonLabel({Color? color}) => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: color ?? Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle telemetryDigits({Color? color}) => GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
  );
}
