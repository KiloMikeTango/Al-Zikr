// lib/presentation/widgets/counter_display.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final double scale;

  const CounterDisplay({super.key, required this.count, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40 * scale, vertical: 20 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20 * scale,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        '$count',
        style: GoogleFonts.philosopher(
          fontSize: 120 * scale,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}