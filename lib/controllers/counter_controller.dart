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
    // single mode
    if (!isPresetMode && currentZikr == null) {
      currentCount++;
      await VibrationService.singleVibrate();
      notifyListeners();
      return;
    }

    // preset finished
    if (isCompleted) return;

    final zikr = currentZikr;
    if (zikr == null) return;

    currentCount++;
    await VibrationService.singleVibrate();

    if (currentCount >= zikr.target) {
      // hit target for this zikr
      await _goNextZikr();
    }

    notifyListeners();
  }

  void reset() {
    currentCount = 0;
    notifyListeners();
  }

  void restartAll() {
    currentZikrIndex = 0;
    currentCount = 0;
    notifyListeners();
  }

  Future<void> _goNextZikr() async {
    // if there is a next zikr: double buzz and advance
    if (currentZikrIndex + 1 < zikrs.length) {
      await VibrationService.doubleVibrate();
      currentZikrIndex++;
      currentCount = 0;
    } else {
      // last zikr finished: triple buzz and clamp
      await VibrationService.tripleVibrate();
      if (currentZikr != null) {
        currentCount = currentZikr!.target;
      }
    }
  }
}
