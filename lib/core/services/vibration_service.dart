// lib/core/services/vibration_service.dart
import 'package:vibration/vibration.dart';

class VibrationService {
  static Future<bool> _canVibrate() async =>
      await Vibration.hasVibrator();

  static Future<void> singleVibrate() async {
    if (await _canVibrate()) {
      await Vibration.vibrate(duration: 40); // light, per-tap
    }
  }

  static Future<void> doubleVibrate() async {
    if (await _canVibrate()) {
      // wait 0, vibrate 80, wait 80, vibrate 80
      await Vibration.vibrate(pattern: [0, 80, 80, 80]);
    }
  }

  static Future<void> tripleVibrate() async {
    if (await _canVibrate()) {
      // wait 0, vibrate 80, wait 80, vibrate 80, wait 80, vibrate 80
      await Vibration.vibrate(pattern: [0, 80, 80, 80, 80, 80]);
    }
  }
}
