import 'package:flutter/material.dart';
import 'dart:math' as math;

class SkeletonOverlay extends StatelessWidget {
  final List<List<double>> keypoints;

  SkeletonOverlay({required this.keypoints});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SkeletonPainter(keypoints),
    );
  }
}

class SkeletonPainter extends CustomPainter {
  final List<List<double>> keypoints;
  SkeletonPainter(this.keypoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (keypoints.isEmpty) return;

    Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < keypoints[0].length; i += 3) {
      double x = keypoints[0][i] * size.width;
      double y = keypoints[0][i + 1] * size.height;

      canvas.drawCircle(Offset(x, y), 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
