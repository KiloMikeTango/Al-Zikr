import 'dart:io';
import 'package:flutter/services.dart';

class VibrationService {
  static Future<void> singleVibrate() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await HapticFeedback.lightImpact();
    }
  }

  static Future<void> doubleVibrate() async {
    await singleVibrate();
    await Future.delayed(const Duration(milliseconds: 80));
    await singleVibrate();
  }
}
