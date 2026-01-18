// lib/controllers/custom_controller.dart
import 'package:al_zikr/models/zikr_items.dart';

import 'counter_controller.dart';

class CustomController {
  final CounterController counter = CounterController();
  final List<ZikrItem> zikrs = [];

  void addZikr(String text, int target) {
    zikrs.add(ZikrItem(text: text, target: target));
  }

  void startCounting() {
    counter.setZikrs(zikrs);
  }
}
