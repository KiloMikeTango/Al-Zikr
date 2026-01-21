import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetButton extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  final VoidCallback onReset;

  const ResetButton({
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