import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Soft topographic contour lines used as a background pattern (a stand-in for the aerial photo in the mockup).
class ContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.9, size.height * 0.25), step = math.min(size.shortestSide * 0.12, 60.0);
    for (var i = 1; i <= 10; i++) {
      final path = Path();
      for (var a = 0; a <= 360; a += 4) {
        final t = a * math.pi / 180, r = i * step * (1 + 0.1 * math.sin(3 * t + i * 0.7) + 0.05 * math.cos(5 * t - i));
        final p = center + Offset(math.cos(t) * r, math.sin(t) * r);
        a == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path..close(), Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = Colors.white.withValues(alpha: 0.07 + i * 0.008));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}