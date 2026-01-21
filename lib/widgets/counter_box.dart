import 'package:al_zikr/controllers/counter_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CounterBox extends StatelessWidget {
  final double Function(double) pxH;
  final double Function(double) pxW;
  const CounterBox({super.key, required this.pxH, required this.pxW});

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