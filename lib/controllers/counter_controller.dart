// lib/controllers/counter_controller.dart
import 'package:al_zikr/models/zikr_items.dart';
import '../core/services/vibration_service.dart';

class CounterController {
  int currentCount = 0;
  int currentZikrIndex = 0;
  List<ZikrItem>? zikrs;
  bool get isCompleted => zikrs != null && currentZikrIndex >= zikrs!.length;

  void tap() {
    currentCount++;
    VibrationService.singleVibrate();

    if (zikrs != null && currentCount >= zikrs![currentZikrIndex].target) {
      VibrationService.doubleVibrate();
      nextZikr();
    }
  }

  void reset() {
    currentCount = 0;
    currentZikrIndex = 0;
  }

  void nextZikr() {
    currentZikrIndex++;
    currentCount = 0;
    if (currentZikrIndex < zikrs!.length) {
      VibrationService.doubleVibrate();
    }
  }

  void setZikrs(List<ZikrItem> items) {
    zikrs = items;
    reset();
  }
}
