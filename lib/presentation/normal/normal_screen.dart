// lib/presentation/normal/normal_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/tap_button.dart';
import '../../widgets/counter_display.dart';
import '../../widgets/confirm_exit_dialog.dart';
import '../../core/constants/colors.dart';
import '../mode_selection/mode_selection_screen.dart';

class NormalScreen extends StatefulWidget {
  const NormalScreen({super.key});

  @override
  State<NormalScreen> createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  final CounterController _controller = CounterController();

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmExitDialog(
        onConfirm: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ModeSelectionScreen()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
                    onPressed: _showExitDialog,
                  ),
                  Text(
                    'NORMAL',
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CounterDisplay(count: _controller.currentCount, large: true),
                    const SizedBox(height: 48),
                    TapButton(
                      large: true,
                      onTap: _controller.tap,
                    ),
                    const SizedBox(height: 24),
                    TapButton(
                      onTap: _controller.reset,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
