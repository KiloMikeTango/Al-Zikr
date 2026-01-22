import 'dart:math' as math;
import 'package:al_zikr/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/custom_controller.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/add_zikr_dialog.dart';
import 'custom_counter_screen.dart';
import 'package:vibration/vibration.dart';

class CustomSetupScreen extends StatelessWidget {
  const CustomSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomController(),
      child: const _CustomSetupBody(),
    );
  }
}

class _CustomSetupBody extends StatelessWidget {
  const _CustomSetupBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CustomController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Custom Floating Action Button to match the theme
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white10),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) =>
              AddZikrDialog(onAdd: (item) => controller.addZikr(item)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                children: [
                  // 1. HEADER
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              actionText: 'EXIT',
                              title: 'EXIT SESSION?',
                              subtitle:
                                  'Your Zikr Setups in this session will not be saved.',
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
                          'CUSTOM SETUP',
                          style: GoogleFonts.philosopher(
                            fontSize: pxH(80),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. LIST OF ZIKRS
                  Positioned.fill(
                    top: pxH(400),
                    bottom: pxH(400),
                    child: controller.zikrs.isEmpty
                        ? Center(
                            child: Text(
                              'No Zikr added yet',
                              style: GoogleFonts.philosopher(
                                color: Colors.white38,
                                fontSize: pxH(60),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: pxW(100),
                              vertical: pxH(50),
                            ),
                            itemCount: controller.zikrs.length,
                            itemBuilder: (context, i) {
                              final z = controller.zikrs[i];
                              return _SmallZikrCard(
                                text: z.text,
                                target: z.target,
                                pxH: pxH,
                                pxW: pxW,
                                onRemove: () => controller.removeAt(i),
                              );
                            },
                          ),
                  ),

                  // 3. START BUTTON
                  Positioned(
                    bottom: pxH(150),
                    left: pxW(200),
                    right: pxW(200),
                    child: GestureDetector(
                      onTap: controller.zikrs.isEmpty
                          ? null
                          : () async {
                              if (await Vibration.hasVibrator()) {
                                Vibration.vibrate(
                                  duration: 40,
                                ); // 40–60ms feels like a tap
                              }
                              final counter = CounterController()
                                ..setZikrs(controller.zikrs);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CustomCounterScreen(counter: counter),
                                ),
                              );
                            },
                      child: Opacity(
                        opacity: controller.zikrs.isEmpty ? 0.3 : 1.0,
                        child: Container(
                          height: pxH(180),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(pxH(90)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'START',
                            style: GoogleFonts.philosopher(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: pxH(70),
                              letterSpacing: 2,
                            ),
                          ),
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

// Compact Zikr Card without the Play Button
class _SmallZikrCard extends StatelessWidget {
  final String text;
  final int target;
  final double Function(double) pxH;
  final double Function(double) pxW;
  final VoidCallback onRemove;

  const _SmallZikrCard({
    required this.text,
    required this.target,
    required this.pxH,
    required this.pxW,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: pxH(40)),
      padding: EdgeInsets.all(pxH(50)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(pxH(40)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.notoSansArabic(
                    color: Colors.white,
                    fontSize: pxH(70),
                  ),
                ),
                Text(
                  'Goal: ${target}x',
                  style: GoogleFonts.philosopher(
                    color: Colors.white38,
                    fontSize: pxH(45),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: Colors.white38,
              size: pxH(80),
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
