// lib/presentation/custom/custom_counter_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/custom_controller.dart';
import '../../widgets/tap_button.dart';
import '../../widgets/counter_display.dart';
import '../../widgets/confirm_exit_dialog.dart';
import '../../core/constants/colors.dart';
import '../mode_selection/mode_selection_screen.dart';

class CustomCounterScreen extends StatefulWidget {
  final CustomController controller;

  const CustomCounterScreen({super.key, required this.controller});

  @override
  State<CustomCounterScreen> createState() => _CustomCounterScreenState();
}

class _CustomCounterScreenState extends State<CustomCounterScreen> {
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
    final zikr = widget.controller.counter.zikrs?.isNotEmpty == true
        ? widget.controller.counter.zikrs![widget.controller.counter.currentZikrIndex]
        : null;

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
                  const Text(
                    'CUSTOM',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textWhite),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CounterDisplay(count: widget.controller.counter.currentCount, large: true),
                    const SizedBox(height: 48),
                    TapButton(
                      large: true,
                      onTap: widget.controller.counter.tap,
                    ),
                    if (zikr != null) ...[
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${widget.controller.counter.currentCount}/${zikr.target}x ${zikr.text}',
                          style: TextStyle(
                            fontSize: isDesktop ? 20 : 16,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ],
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
