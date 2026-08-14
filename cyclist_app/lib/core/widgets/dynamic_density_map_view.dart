import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DynamicDensityMapView extends StatelessWidget {
  final String title;
  final String? filterSubtitle;
  final bool showSosPins;
  final bool isLeaderScope;
  final double height;

  const DynamicDensityMapView({
    super.key,
    this.title = 'Interactive Live Dynamic Density Map',
    this.filterSubtitle,
    this.showSosPins = true,
    this.isLeaderScope = false,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1322),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderHighlight.withOpacity(0.4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Custom Painted Map Grid, Polyline and Dynamic Shading Clusters
            CustomPaint(
              size: Size.infinite,
              painter: _MapCanvasPainter(isLeaderScope: isLeaderScope),
            ),

            // Top Status Bar Overlay
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xCC090D16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.domainCycling,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isLeaderScope ? '📍 Team Live GPS (38 Riders)' : '🌐 Domain Live Feed (1,248 Pax)',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xCC090D16),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '⚡ 50ms Ping',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Dynamic Density Color Step Legend
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xE6090D16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _legendItem(AppColors.densitySparse, '1-25 (Sparse)'),
                    _legendItem(AppColors.densityModerate, '25-100'),
                    _legendItem(AppColors.densityHigh, '100-300'),
                    _legendItem(AppColors.densityVeryHigh, '300-600'),
                    _legendItem(AppColors.densityExtreme, '600+ (Extreme)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final bool isLeaderScope;
  _MapCanvasPainter({required this.isLeaderScope});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x0F2979FF)
      ..strokeWidth = 1;

    // Background Map Grid Lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Official Rally Route Polyline (Cyan Glow)
    final routePaint = Paint()
      ..color = AppColors.domainCycling.withOpacity(0.7)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.cubicTo(
      size.width * 0.25, size.height * 0.3,
      size.width * 0.55, size.height * 0.8,
      size.width * 0.88, size.height * 0.35,
    );
    canvas.drawPath(path, routePaint);

    // Dynamic Step Density Clusters along the route
    if (!isLeaderScope) {
      // SuperAdmin View: Large multi-tier clusters
      _drawDensityCluster(canvas, Offset(size.width * 0.4, size.height * 0.5), AppColors.densityExtreme, 450, 26);
      _drawDensityCluster(canvas, Offset(size.width * 0.7, size.height * 0.55), AppColors.densityHigh, 180, 20);
      _drawDensityCluster(canvas, Offset(size.width * 0.22, size.height * 0.45), AppColors.densityModerate, 65, 15);
    } else {
      // Leader View: Team cluster at muster point & en route
      _drawDensityCluster(canvas, Offset(size.width * 0.3, size.height * 0.4), AppColors.densityModerate, 30, 18);
      _drawDensityCluster(canvas, Offset(size.width * 0.6, size.height * 0.6), AppColors.densitySparse, 6, 12);
    }

    // Checkpoint Markers
    _drawMarker(canvas, Offset(size.width * 0.1, size.height * 0.7), '🚩 Start');
    _drawMarker(canvas, Offset(size.width * 0.5, size.height * 0.65), '💧 Water');
    _drawMarker(canvas, Offset(size.width * 0.88, size.height * 0.35), '🏁 Finish');

    // SOS Pin
    _drawSosPin(canvas, Offset(size.width * 0.65, size.height * 0.4));
  }

  void _drawDensityCluster(Canvas canvas, Offset center, Color color, int count, double radius) {
    // Outer Glow Ring
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius + 8, glowPaint);

    // Core Cluster Circle
    final corePaint = Paint()
      ..color = color.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, corePaint);

    // Count text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawMarker(Canvas canvas, Offset offset, String label) {
    final paint = Paint()..color = Colors.white;
    canvas.drawCircle(offset, 4, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset + const Offset(-12, 6));
  }

  void _drawSosPin(Canvas canvas, Offset offset) {
    final sosGlow = Paint()
      ..color = AppColors.sosRed.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 14, sosGlow);

    final sosCore = Paint()..color = AppColors.sosRed;
    canvas.drawCircle(offset, 7, sosCore);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
