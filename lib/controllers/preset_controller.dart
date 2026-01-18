import 'package:al_zikr/models/preset_model.dart';
import 'package:flutter/foundation.dart';
import '../core/services/storage_service.dart';

class PresetController extends ChangeNotifier {
  List<PresetModel> presets = [];

  Future<void> load() async {
    presets = await StorageService.loadPresets();
    notifyListeners();
  }

  Future<void> addPreset(PresetModel preset) async {
    presets.add(preset);
    await StorageService.savePresets(presets);
    notifyListeners();
  }

  Future<void> deletePreset(int index) async {
    presets.removeAt(index);
    await StorageService.savePresets(presets);
    notifyListeners();
  }
}
