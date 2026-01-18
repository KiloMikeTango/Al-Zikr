import 'package:al_zikr/models/zikr_items.dart';
import 'package:flutter/foundation.dart';
import '../core/services/vibration_service.dart';

class CounterController extends ChangeNotifier {
  int currentCount = 0;
  int currentZikrIndex = 0;
  List<ZikrItem> zikrs = [];

  bool get hasZikrs => zikrs.isNotEmpty;
  ZikrItem? get currentZikr =>
      hasZikrs && currentZikrIndex < zikrs.length ? zikrs[currentZikrIndex] : null;

  void setSingleMode() {
    zikrs = [];
    currentZikrIndex = 0;
    currentCount = 0;
    notifyListeners();
  }

  void setZikrs(List<ZikrItem> items) {
    zikrs = items;
    currentZikrIndex = 0;
    currentCount = 0;
    notifyListeners();
  }

  Future<void> tap() async {
    currentCount++;
    await VibrationService.singleVibrate();

    if (currentZikr != null && currentCount >= currentZikr!.target) {
      // hit target
      await VibrationService.doubleVibrate();
      _goNextZikr();
    }
    notifyListeners();
  }

  void reset() {
    currentCount = 0;
    currentZikrIndex = 0;
    notifyListeners();
  }

  Future<void> _goNextZikr() async {
    if (currentZikrIndex + 1 < zikrs.length) {
      currentZikrIndex++;
      currentCount = 0;
      // switch zikr feedback
      await VibrationService.doubleVibrate();
    } else {
      // finished all zikr, keep last state but don’t overflow
      currentCount = currentZikr!.target;
    }
  }
}
