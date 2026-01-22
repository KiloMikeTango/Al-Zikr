import 'dart:math' as math;
import 'package:al_zikr/widgets/confirm_dialog.dart';
import 'package:al_zikr/widgets/counter_box.dart';
import 'package:al_zikr/widgets/reset_button.dart';
import 'package:al_zikr/widgets/tap_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
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
                          onTap: () =>
                              //exit to mode selection screen
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  actionText: 'EXIT',
                                  title: 'EXIT SESSION?',
                                  subtitle:
                                      'Your progress in this session will not be saved.',
                                  onConfirm: () => Navigator.pop(context),
                                ),
                              ),

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
                    child: CounterBox(pxH: pxH, pxW: pxW),
                  ),

                  // 3. RESET BUTTON (Right-Side)
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

                  // 4. MAIN TAP CIRCLE (True Center)
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
