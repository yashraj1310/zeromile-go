import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StaticRoutePreviewMap extends StatelessWidget {
  final String routeSummary;
  final double height;

  const StaticRoutePreviewMap({
    super.key,
    required this.routeSummary,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _StaticMapPainter(),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xCC090D16),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_clock_outlined, size: 12, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      '🏁 Static Route Preview (Live GPS & SOS Offline)',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xEB090D16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  routeSummary,
                  style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.7);
    path.cubicTo(
      size.width * 0.35, size.height * 0.25,
      size.width * 0.65, size.height * 0.75,
      size.width * 0.85, size.height * 0.35,
    );
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
