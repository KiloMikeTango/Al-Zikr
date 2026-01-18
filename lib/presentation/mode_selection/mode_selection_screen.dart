// lib/presentation/mode_selection/mode_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../widgets/zikr_card.dart';
import '../normal/normal_screen.dart';
import '../custom/custom_setup_screen.dart';
import '../presets/presets_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: const _ModeContent(),
            tablet: const Center(child: SizedBox(width: 450, child: _ModeContent())),
            desktop: const Center(child: SizedBox(width: 500, child: _ModeContent())),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          
          // Header section instead of a big gap
          Text(
            'SELECT MODE',
            style: GoogleFonts.philosopher(
              color: Colors.white54,
              fontSize: 14,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 40),

          ZikrCard(
            title: 'NORMAL',
            icon: Icons.play_arrow_rounded,
            isAction: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NormalScreen())),
          ),
          const SizedBox(height: 16),
          ZikrCard(
            title: 'CUSTOM',
            icon: Icons.tune_rounded,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomSetupScreen())),
          ),
          const SizedBox(height: 16),
          ZikrCard(
            title: 'YOUR PRESETS',
            icon: Icons.bookmarks_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PresetsScreen())),
          ),

          const Spacer(flex: 3),
          
          Opacity(
            opacity: 0.1,
            child: Text(
              'AL Zikr',
              style: GoogleFonts.lobster(fontSize: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}