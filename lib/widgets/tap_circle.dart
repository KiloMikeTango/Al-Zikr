import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TapCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double Function(double) pxW;
  final double Function(double) pxH;

  const TapCircle({super.key, required this.onTap, required this.pxW, required this.pxH});

  @override
  Widget build(BuildContext context) {
    final size = pxW(850);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF252525), Color(0xFF181818)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 2,
                ),
              ),
            ),
            CustomPaint(size: Size(size, size), painter: DashedCirclePainter()),
            Text(
              'TAP',
              style: GoogleFonts.philosopher(
                fontSize: pxH(100),
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashCount = 50;
    const dashWidth = (2 * math.pi) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashWidth * 2,
        dashWidth,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
