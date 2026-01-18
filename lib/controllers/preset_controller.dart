// lib/controllers/preset_controller.dart
import 'package:al_zikr/models/presnt_model.dart';

import '../core/services/storage_service.dart';

class PresetController {
  Future<List<PresetModel>> loadPresets() => StorageService.getPresets();

  Future<void> savePreset(PresetModel preset) => StorageService.savePreset(preset);

  Future<void> deletePreset(int index) => StorageService.deletePreset(index);
}
