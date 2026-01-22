import 'package:al_zikr/models/zikr_items.dart';
import 'package:flutter/foundation.dart';
import '../core/services/vibration_service.dart';

class CounterController extends ChangeNotifier {
  int currentCount = 0;
  int currentZikrIndex = 0;
  List<ZikrItem> zikrs = [];

  bool get hasZikrs => zikrs.isNotEmpty;

  ZikrItem? get currentZikr => hasZikrs && currentZikrIndex < zikrs.length
      ? zikrs[currentZikrIndex]
      : null;

  bool get isPresetMode => zikrs.isNotEmpty;

  bool get isCompleted =>
      isPresetMode &&
      currentZikrIndex == zikrs.length - 1 &&
      currentZikr != null &&
      currentCount >= currentZikr!.target;

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
    // single mode behavior: just increment
    if (!isPresetMode && currentZikr == null) {
      currentCount++;
      await VibrationService.singleVibrate();
      notifyListeners();
      return;
    }

    // preset mode finished: ignore taps
    if (isCompleted) return;

    // multi‑zikr mode
    if (currentZikr == null) return;

    if (currentCount < currentZikr!.target) {
      currentCount++;
      await VibrationService.singleVibrate();

      if (currentCount >= currentZikr!.target) {
        // hit target
        await VibrationService.doubleVibrate();
        await _goNextZikr();
      }
      notifyListeners();
    }
  }

  /// Reset only the current zikr count
  void reset() {
    currentCount = 0;
    notifyListeners();
  }

  /// Restart from first zikr and reset its count
  void restartAll() {
    currentZikrIndex = 0;
    currentCount = 0;
    notifyListeners();
  }

  Future<void> _goNextZikr() async {
    if (currentZikrIndex + 1 < zikrs.length) {
      currentZikrIndex++;
      currentCount = 0;
      await VibrationService.doubleVibrate();
    } else {
      // finished all zikr, clamp to last target
      if (currentZikr != null) {
        currentCount = currentZikr!.target;
      }
    }
  }
}
