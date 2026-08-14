import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable Glassmorphic Container with BackdropFilter blur and 1px highlight border
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? customColor;
  final Border? customBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 18.0,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.customColor,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.surfaceGlass : const Color(0xD9FFFFFF);
    final defaultBorder = Border.all(
      color: isDark ? AppColors.borderSubtle : const Color(0x140F172A),
      width: 1.0,
    );

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: customColor ?? defaultBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: customBorder ?? defaultBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
