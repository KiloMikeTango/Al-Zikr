// lib/presentation/custom/custom_counter_screen.dart
import 'dart:math' as math;
import 'package:al_zikr/widgets/confirm_dialog.dart';
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

class _CustomCounterBody extends StatefulWidget {
  final String title;
  const _CustomCounterBody({required this.title});

  @override
  State<_CustomCounterBody> createState() => _CustomCounterBodyState();
}

class _CustomCounterBodyState extends State<_CustomCounterBody> {
  final ScrollController _scrollController = ScrollController();
  String? _lastZikrText;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLine(double scale, bool forward) {
    if (!_scrollController.hasClients) return;

    final double lineHeight = 75 * 1.6 * scale;
    final double targetOffset = forward
        ? _scrollController.offset + lineHeight
        : _scrollController.offset - lineHeight;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    final zikr = c.currentZikr;

    // Reset Scroll when Zikr changes
    if (zikr != null && zikr.text != _lastZikrText) {
      _lastZikrText = zikr.text;
      if (_scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    }

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

              final bool isLongText = (zikr?.text.length ?? 0) > 40;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 1. TOP BAR
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                actionText: 'EXIT',
                                title: 'EXIT SESSION?',
                                subtitle:
                                    'Your progress in this session will not be saved.',
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
                          widget.title.toUpperCase(),
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

                  // 2. COUNTER BOX
                  Positioned(
                    top: pxH(550),
                    child: CounterBox(pxH: pxH, pxW: pxW),
                  ),

                  // 3. RESET BUTTON
                  Positioned(
                    right: pxW(120),
                    top: pxH(1050),
                    child: ResetButton(
                      pxH: pxH,
                      pxW: pxW,
                      onReset: () => context.read<CounterController>().reset(),
                    ),
                  ),

                  // 4. MAIN TAP CIRCLE
                  Positioned(
                    top: pxH(1250),
                    child: TapCircle(
                      pxW: pxW,
                      pxH: pxH,
                      onTap: () async {
                        if (await Vibration.hasVibrator()) {
                          Vibration.vibrate(duration: 40);
                        }
                        context.read<CounterController>().tap();
                      },
                    ),
                  ),

                  // 5. ZIKR INFO BOX (Consistent Scrolling + Transition Animation)
                  if (zikr != null)
                    Positioned(
                      bottom: pxH(400),
                      child: Container(
                        width: pxW(1300),
                        height: pxH(300),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(pxH(50)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Left side Target Count
                            Container(
                              width: pxW(280),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                              ),
                              child: Text(
                                '${zikr.target}x',
                                style: GoogleFonts.philosopher(
                                  fontSize: pxH(70),
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Right side Stepper Text with Cross-Fade
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                            Colors.black,
                                            Colors.transparent,
                                          ],
                                          stops: [0.0, 0.3, 0.7, 1.0],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: pxH(85),
                                          ),
                                          // AnimatedSwitcher handles the Cross-Fade transition
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            transitionBuilder:
                                                (
                                                  Widget child,
                                                  Animation<double> animation,
                                                ) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                            child: Text(
                                              zikr.text,
                                              key: ValueKey<String>(
                                                zikr.text,
                                              ), // Key is vital for AnimatedSwitcher
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.notoSansArabic(
                                                fontSize: pxH(75),
                                                color: Colors.white,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Arrows
                                  Padding(
                                    padding: EdgeInsets.only(right: pxW(25)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: isLongText
                                              ? () => _scrollLine(scale, false)
                                              : null,
                                          child: Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: isLongText
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.white.withOpacity(
                                                    0.05,
                                                  ),
                                            size: pxH(75),
                                          ),
                                        ),
                                        SizedBox(height: pxH(10)),
                                        GestureDetector(
                                          onTap: isLongText
                                              ? () => _scrollLine(scale, true)
                                              : null,
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: isLongText
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.white.withOpacity(
                                                    0.05,
                                                  ),
                                            size: pxH(75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 6. BRANDING
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
