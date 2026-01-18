// lib/presentation/mode_selection/mode_selection_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/zikr_card.dart';
import '../../core/responsive/responsive_layout.dart';
import '../normal/normal_screen.dart';
import '../custom/custom_setup_screen.dart';
import '../presets/presets_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryBlack, AppColors.secondaryDark],
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildWideLayout(context),
            desktop: _buildWideLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(flex: 1),
          ZikrCard(
            title: 'NORMAL',
            icon: Icons.play_arrow,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NormalScreen())),
          ),
          ZikrCard(
            title: 'CUSTOM',
            icon: Icons.settings,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomSetupScreen())),
          ),
          ZikrCard(
            title: 'YOUR PRESETS',
            icon: Icons.list,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PresetsScreen())),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(48),
        child: _buildMobileLayout(context),
      ),
    );
  }
}
