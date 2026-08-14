import 'package:flutter/material.dart';

/// Interactive container that tilts subtly based on mouse cursor or gyro motion
class ParallaxTiltContainer extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle; // In degrees
  final BorderRadius? borderRadius;

  const ParallaxTiltContainer({
    super.key,
    required this.child,
    this.maxTiltAngle = 4.0,
    this.borderRadius,
  });

  @override
  State<ParallaxTiltContainer> createState() => _ParallaxTiltContainerState();
}

class _ParallaxTiltContainerState extends State<ParallaxTiltContainer> {
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = context.size ?? const Size(300, 200);
        final dx = (event.localPosition.dx - (size.width / 2)) / (size.width / 2);
        final dy = (event.localPosition.dy - (size.height / 2)) / (size.height / 2);
        setState(() {
          _tiltX = -dy * (widget.maxTiltAngle * 3.14159 / 180);
          _tiltY = dx * (widget.maxTiltAngle * 3.14159 / 180);
        });
      },
      onExit: (_) {
        setState(() {
          _tiltX = 0.0;
          _tiltY = 0.0;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_tiltX)
          ..rotateY(_tiltY),
        alignment: FractionalOffset.center,
        child: widget.child,
      ),
    );
  }
}
