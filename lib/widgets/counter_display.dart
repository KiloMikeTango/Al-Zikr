// lib/widgets/counter_display.dart
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final bool large;

  const CounterDisplay({
    super.key,
    required this.count,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final fontSize = isDesktop ? (large ? 80.0 : 40.0) : (large ? 60.0 : 32.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.counterGlow.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          shadows: [
            Shadow(
              color: AppColors.counterGlow,
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
