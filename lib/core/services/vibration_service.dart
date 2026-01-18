// lib/core/services/vibration_service.dart
import 'package:flutter/services.dart';
import 'dart:io';

class VibrationService {
  static Future<void> singleVibrate() async {
    if (Platform.isAndroid || Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
  }

  static Future<void> doubleVibrate() async {
    await singleVibrate();
    await Future.delayed(const Duration(milliseconds: 100));
    await singleVibrate();
  }
}
