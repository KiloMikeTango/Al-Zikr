// lib/presentation/custom/custom_counter_screen.dart
import 'dart:math' as math;
import 'package:al_zikr/widgets/confirm_exit_dialog.dart';
import 'package:al_zikr/widgets/counter_box.dart';
import 'package:al_zikr/widgets/reset_button.dart';
import 'package:al_zikr/widgets/tap_circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
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
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmExitDialog(
                                onConfirm: () => Navigator.pop(context),
                              ),
                            );
                          },
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
                    child: CounterBox(pxH: pxH, pxW: pxW),
                  ),

                  // 3. RESET BUTTON (Exact same as Normal Screen)
                  Positioned(
                    right: pxW(120),
                    top: pxH(1050),
                    child: ResetButton(
                      pxH: pxH,
                      pxW: pxW,
                      onReset: () {
                        context.read<CounterController>().reset();
                      },
                    ),
                  ),

                  // 4. MAIN TAP CIRCLE (Exact same as Normal Screen)
                  Positioned(
                    top: pxH(1250),
                    child: TapCircle(
                      pxW: pxW,
                      pxH: pxH,
                      onTap: () async {
                        if (await Vibration.hasVibrator()) {
                          Vibration.vibrate(
                            duration: 40,
                          ); // 40–60ms feels like a tap
                        }
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
