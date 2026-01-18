// controllers/preset_controller.dart
import 'package:flutter/foundation.dart';
import '../core/services/storage_service.dart';
import '../models/preset_model.dart';

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

  Future<void> updatePreset(int index, PresetModel preset) async {
    presets[index] = preset;
    await StorageService.savePresets(presets);
    notifyListeners();
  }

  Future<void> deletePreset(int index) async {
    presets.removeAt(index);
    await StorageService.savePresets(presets);
    notifyListeners();
  }
}
