// lib/widgets/session_end_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SessionChoice { startOver, exit }

class SessionEndDialog extends StatelessWidget {
  const SessionEndDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const baseW = 1440.0;
    const baseH = 2880.0;
    final scale = math.min(size.width / baseW, size.height / baseH);

    double pxW(double v) => v * scale;
    double pxH(double v) => v * scale;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: pxW(150)),
      child: Container(
        padding: EdgeInsets.all(pxH(80)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(pxH(60)),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 50,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PRESET COMPLETED',
              style: GoogleFonts.philosopher(
                color: Colors.white,
                fontSize: pxH(70),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: pxH(40)),
            Text(
              'You have finished all zikr in this preset.',
              textAlign: TextAlign.center,
              style: GoogleFonts.philosopher(
                color: Colors.white38,
                fontSize: pxH(45),
              ),
            ),
            SizedBox(height: pxH(100)),
            Row(
              children: [
                // EXIT
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop<SessionChoice>(
                      context,
                      SessionChoice.exit,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: pxH(40)),
                      alignment: Alignment.center,
                      child: Text(
                        'EXIT',
                        style: GoogleFonts.philosopher(
                          color: Colors.white38,
                          fontSize: pxH(45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: pxW(40)),
                // START OVER
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop<SessionChoice>(
                      context,
                      SessionChoice.startOver,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: pxH(40)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(pxH(100)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'START OVER',
                        style: GoogleFonts.philosopher(
                          color: Colors.black,
                          fontSize: pxH(45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
