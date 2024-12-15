import 'package:flutter/material.dart';

class CustomDashedCircle extends StatelessWidget {
  final double size;
  final List<Color> dashColors;

  const CustomDashedCircle({
    super.key,
    required this.size,
    required this.dashColors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DashedCirclePainter(dashColors: dashColors),
      child: Center(
        child: Container(
          width: size * 0.45,
          height: size * 0.45,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: ClipOval(
              child: Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final List<Color> dashColors;

  DashedCirclePainter({required this.dashColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final radius = size.width / 2;
    const dashCount = 3;
    const gapAngle = 0.05; // Minimum spacing between dashes
    const dashAngle = (2 * 3.14159265 / dashCount) - gapAngle;

    for (int i = 0; i < dashCount; i++) {
      paint.color = dashColors[i % dashColors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        (dashAngle + gapAngle) * i, // Start of each dash
        dashAngle, // Dash length
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
