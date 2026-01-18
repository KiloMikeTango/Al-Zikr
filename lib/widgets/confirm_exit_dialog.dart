// lib/widgets/confirm_exit_dialog.dart
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class ConfirmExitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmExitDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Exit Counter?', style: TextStyle(color: AppColors.textWhite)),
      content: const Text(
        'This counter will not be saved',
        style: TextStyle(color: AppColors.textWhite),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textWhite)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
          child: const Text('Exit', style: TextStyle(color: AppColors.primaryBlack)),
        ),
      ],
    );
  }
}
