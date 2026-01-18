// lib/widgets/add_zikr_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/zikr_items.dart';

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
    // Scaling logic for the dialog
    final size = MediaQuery.of(context).size;
    const baseW = 1440.0;
    const baseH = 2880.0;
    final scale = math.min(size.width / baseW, size.height / baseH);

    double pxW(double v) => v * scale;
    double pxH(double v) => v * scale;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: pxW(100)),
      child: Container(
        padding: EdgeInsets.all(pxH(80)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(pxH(60)),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ADD NEW ZIKR',
              style: GoogleFonts.philosopher(
                color: Colors.white,
                fontSize: pxH(70),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: pxH(80)),

            // Zikr Text Input
            _buildTextField(
              controller: _textController,
              label: 'ZIKR NAME (ARABIC / TEXT)',
              pxH: pxH,
            ),
            SizedBox(height: pxH(60)),

            // Target Count Input
            _buildTextField(
              controller: _targetController,
              label: 'TARGET COUNT',
              isNumber: true,
              pxH: pxH,
            ),
            SizedBox(height: pxH(100)),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: pxH(40)),
                      alignment: Alignment.center,
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.philosopher(
                          color: Colors.white38,
                          fontSize: pxH(50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: pxW(40)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final text = _textController.text;
                      final target = int.tryParse(_targetController.text) ?? 0;
                      if (text.isNotEmpty && target > 0) {
                        widget.onAdd(ZikrItem(text: text, target: target));
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: pxH(40)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(pxH(100)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ADD',
                        style: GoogleFonts.philosopher(
                          color: Colors.black,
                          fontSize: pxH(50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required double Function(double) pxH,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.philosopher(
            color: Colors.white70,
            fontSize: pxH(50),
            letterSpacing: 1,
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
