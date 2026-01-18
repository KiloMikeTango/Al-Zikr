// lib/widgets/tap_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/colors.dart';

class TapButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool large;

  const TapButton({
    super.key,
    required this.onTap,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final size = isDesktop ? (large ? 200.0 : 80.0) : (large ? 140.0 : 60.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => HapticFeedback.lightImpact(),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.neonGlow.withOpacity(0.3), AppColors.secondaryDark],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGlow.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.primaryBlack.withOpacity(0.5),
                blurRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
