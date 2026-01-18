// lib/presentation/mode_selection/mode_selection_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/responsive/responsive_layout.dart';
import '../normal/normal_screen.dart';
import '../custom/custom_setup_screen.dart';
import '../presets/presets_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

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
          child: ResponsiveLayout(
            mobile: const _ModeContent(),
            tablet: const Center(
              child: SizedBox(width: 450, child: _ModeContent()),
            ),
            desktop: const Center(
              child: SizedBox(width: 500, child: _ModeContent()),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeContent extends StatelessWidget {
  const _ModeContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(
          constraints.maxWidth / 1440.0,
          constraints.maxHeight / 2880.0,
        );
        double pxH(double v) => v * scale;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (constraints.maxWidth * 0.08),
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Minimalist Header
              Text(
                'SELECT MODE',
                style: GoogleFonts.philosopher(
                  color: Colors.white,
                  fontSize: pxH(80),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),

              // Decorative line matching the "Ghost" style
              Container(
                margin: EdgeInsets.only(top: pxH(30)),
                height: 1,
                width: pxH(200),
                color: Colors.white10,
              ),

              const Spacer(flex: 2),

              // Mode Cards - Icons removed for a cleaner look
              _SelectionCard(
                title: 'NORMAL',
                subtitle: 'Simple single-zikr counter',
                pxH: pxH,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NormalScreen()),
                ),
              ),

              SizedBox(height: pxH(50)),

              _SelectionCard(
                title: 'CUSTOM',
                subtitle: 'Setup a quick session',
                pxH: pxH,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomSetupScreen()),
                ),
              ),

              SizedBox(height: pxH(50)),

              _SelectionCard(
                title: 'PRESETS',
                subtitle: 'Access your saved presets',
                pxH: pxH,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PresetsScreen()),
                ),
              ),

              const Spacer(flex: 6),

              // Bottom Branding (Philosophy style)
              Opacity(
                opacity: 0.1,
                child: Text(
                  'AL Zikr',
                  style: GoogleFonts.lobster(
                    fontSize: pxH(140),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: pxH(100)),
            ],
          ),
        );
      },
    );
  }
}

// Internal component for the Selection Cards to ensure UI match
class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double Function(double) pxH;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.pxH,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: pxH(80), horizontal: pxH(100)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(pxH(50)),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.philosopher(
                color: Colors.white,
                fontSize: pxH(80),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: pxH(10)),
            Text(
              subtitle,
              style: GoogleFonts.philosopher(
                color: Colors.white24,
                fontSize: pxH(55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
