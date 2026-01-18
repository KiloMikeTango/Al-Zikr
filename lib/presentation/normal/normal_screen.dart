import 'dart:math' as math;
import 'package:flutter/material.dart';
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
            colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Figma base canvas 1440 x 2880
              const baseW = 1440.0;
              const baseH = 2880.0;
              final scaleW = width / baseW;
              final scaleH = height / baseH;
              final scale = math.min(scaleW, scaleH);

              double pxW(double v) => v * scale;
              double pxH(double v) => v * scale;

              return Stack(
                children: [
                  // TOP BAR: back + NORMAL
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                            size: pxH(120),
                          ),
                        ),
                        SizedBox(width: pxW(60)),
                        Text(
                          'NORMAL',
                          style: GoogleFonts.philosopher(
                            fontSize: pxH(90),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Counter box
                  Positioned(
                    left: pxW(450),
                    top: pxH(550),
                    width: pxW(540),
                    height: pxH(340),
                    child: _CounterBox(pxH: pxH),
                  ),

                  // RESET button
                  Positioned(
                    right: pxW(100),
                    top: pxH(1000),
                    child: _ResetCard(
                      pxH: pxH,
                      pxW: pxW,
                      onReset: () => context.read<CounterController>().reset(),
                    ),
                  ),

                  // TAP circle
                  Positioned(
                    left: width / 2 - pxW(375),
                    top: pxH(1150),
                    width: pxW(750),
                    height: pxW(750),
                    child: _TapCircle(
                      pxW: pxW,
                      pxH: pxH,
                      onTap: () => context.read<CounterController>().tap(),
                    ),
                  ),

                  // Bottom "AL Zikr" decoration
                  Positioned(
                    bottom: pxH(150),
                    left: 0,
                    right: 0,
                    child: Center(child: _BottomBrand(pxH: pxH)),
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
  const _CounterBox({required this.pxH});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterController>().currentCount;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(pxH(20)),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Center(
        child: Text(
          '$count',
          style: GoogleFonts.vt323(
            // Digital look
            fontSize: pxH(220),
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
    final size = pxW(750);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: DashedCirclePainter(),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Text(
            'TAP',
            style: GoogleFonts.philosopher(
              fontSize: pxH(80),
              fontWeight: FontWeight.w400,
              letterSpacing: 6,
              color: Colors.white,
            ),
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
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Drawing two circles to match the double-line look in the image
    _drawDashedCircle(canvas, center, radius, paint, 40);
    _drawDashedCircle(canvas, center, radius - 8, paint, 40);
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    int dashCount,
  ) {
    final double dashWidth = (2 * math.pi) / (dashCount * 2);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResetCard extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  final VoidCallback onReset;

  const _ResetCard({
    required this.pxH,
    required this.pxW,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pxW(60), vertical: pxH(30)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(pxH(100)), // Pill shape
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          'RESET',
          style: GoogleFonts.philosopher(
            fontSize: pxH(50),
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _BottomBrand extends StatelessWidget {
  final double Function(double) pxH;
  const _BottomBrand({required this.pxH});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Text(
        'AL Zikr',
        style: GoogleFonts.lobster(fontSize: pxH(150), color: Colors.white),
      ),
    );
  }
}
