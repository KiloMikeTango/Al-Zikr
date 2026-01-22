import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartOverButton extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  final VoidCallback onStartOver;

  const StartOverButton({
    super.key,
    required this.pxH,
    required this.pxW,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStartOver,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pxW(70), vertical: pxH(35)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(pxH(100)),
        ),
        child: Text(
          'START OVER',
          style: GoogleFonts.philosopher(
            fontSize: pxH(50),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
