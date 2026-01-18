import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/counter_controller.dart';

class NormalScreen extends StatelessWidget {
  const NormalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterController()..setSingleMode(),
      child: const _NormalBody(),
    );
  }
}

class _NormalBody extends StatelessWidget {
  const _NormalBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Base scale logic maintained
              const baseW = 1440.0;
              const baseH = 2880.0;
              final scale = math.min(width / baseW, height / baseH);

              double pxW(double v) => v * scale;
              double pxH(double v) => v * scale;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 1. TOP BAR: Back + Title
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: pxH(100),
                          ),
                        ),
                        SizedBox(width: pxW(60)),
                        Text(
                          'NORMAL',
                          style: GoogleFonts.philosopher(
                            fontSize: pxH(90),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. COUNTER BOX (Top-Center)
                  Positioned(
                    top: pxH(550),
                    child: _CounterBox(pxH: pxH, pxW: pxW),
                  ),

                  // 3. RESET BUTTON (Right-Side)
                  Positioned(
                    right: pxW(120),
                    top: pxH(1050),
                    child: _ResetButton(
                      pxH: pxH,
                      pxW: pxW,
                      onReset: () {
                        HapticFeedback.mediumImpact();
                        context.read<CounterController>().reset();
                      },
                    ),
                  ),

                  // 4. MAIN TAP CIRCLE (True Center)
                  Positioned(
                    top: pxH(1250),
                    child: _TapCircle(
                      pxW: pxW,
                      pxH: pxH,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.read<CounterController>().tap();
                      },
                    ),
                  ),

                  // 5. BOTTOM BRANDING
                  Positioned(
                    bottom: pxH(150),
                    child: Opacity(
                      opacity: 0.1,
                      child: Text(
                        'AL Zikr',
                        style: GoogleFonts.lobster(
                          fontSize: pxH(140),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CounterBox extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  const _CounterBox({required this.pxH, required this.pxW});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterController>().currentCount;

    return Container(
      width: pxW(550),
      height: pxH(350),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(pxH(30)),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$count',
          style: GoogleFonts.philosopher(
            fontSize: pxH(200),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TapCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double Function(double) pxW;
  final double Function(double) pxH;

  const _TapCircle({required this.onTap, required this.pxW, required this.pxH});

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
            // Inner decorative ring
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
            // Outer dashed ring
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

class _ResetButton extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  final VoidCallback onReset;

  const _ResetButton({
    required this.pxH,
    required this.pxW,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pxW(70), vertical: pxH(35)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(pxH(100)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          'RESET',
          style: GoogleFonts.philosopher(
            fontSize: pxH(50),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white70,
          ),
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
