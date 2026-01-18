import 'package:al_zikr/models/zikr_items.dart';
import 'package:flutter/foundation.dart';

class CustomController extends ChangeNotifier {
  final List<ZikrItem> zikrs = [];

  void addZikr(ZikrItem item) {
    zikrs.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    zikrs.removeAt(index);
    notifyListeners();
  }
}
