// lib/widgets/add_zikr_dialog.dart
import 'package:al_zikr/models/zikr_items.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class AddZikrDialog extends StatefulWidget {
  final Function(ZikrItem) onAdd;

  const AddZikrDialog({super.key, required this.onAdd});

  @override
  State<AddZikrDialog> createState() => _AddZikrDialogState();
}

class _AddZikrDialogState extends State<AddZikrDialog> {
  final _textController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Zikr', style: TextStyle(color: AppColors.textWhite)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: const InputDecoration(
              labelText: 'Zikr Text',
              labelStyle: TextStyle(color: AppColors.textWhite),
              border: OutlineInputBorder(),
              fillColor: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: const InputDecoration(
              labelText: 'Target Count',
              labelStyle: TextStyle(color: AppColors.textWhite),
              border: OutlineInputBorder(),
              fillColor: AppColors.primaryBlack,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textWhite)),
        ),
        ElevatedButton(
          onPressed: () {
            final text = _textController.text;
            final target = int.tryParse(_targetController.text) ?? 0;
            if (text.isNotEmpty && target > 0) {
              widget.onAdd(ZikrItem(text: text, target: target));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
          child: const Text('Add', style: TextStyle(color: AppColors.primaryBlack)),
        ),
      ],
    );
  }
}
