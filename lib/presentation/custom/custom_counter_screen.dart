// lib/presentation/custom/custom_counter_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/counter_controller.dart';

class CustomCounterScreen extends StatelessWidget {
  final CounterController counter;
  final String title;

  const CustomCounterScreen({
    super.key,
    required this.counter,
    this.title = 'CUSTOM',
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: counter,
      child: _CustomCounterBody(title: title),
    );
  }
}

class _CustomCounterBody extends StatelessWidget {
  final String title;
  const _CustomCounterBody({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    final zikr = c.currentZikr;

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
                          title.toUpperCase(),
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

                  // 2. COUNTER BOX (Exact same as Normal Screen)
                  Positioned(
                    top: pxH(550),
                    child: _CounterBox(pxH: pxH, pxW: pxW),
                  ),

                  // 3. RESET BUTTON (Exact same as Normal Screen)
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

                  // 4. MAIN TAP CIRCLE (Exact same as Normal Screen)
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

                  // 5. ZIKR INFO BOX (Custom for this screen)
                  if (zikr != null)
                    Positioned(
                      bottom: pxH(400),
                      child: Container(
                        width: pxW(1150),
                        height: pxH(280),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(pxH(40)),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            // Left Side: Target Count
                            Container(
                              width: pxW(300),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Text(
                                '${zikr.target}x',
                                style: GoogleFonts.philosopher(
                                  fontSize: pxH(70),
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Right Side: Zikr Text
                            Expanded(
                              child: Center(
                                child: Text(
                                  zikr.text,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSansArabic(
                                    fontSize: pxH(80),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 6. BOTTOM BRANDING
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

// --- Internal Components (Exact duplicates from Normal Screen for consistency) ---

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
