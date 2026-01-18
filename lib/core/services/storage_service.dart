// lib/core/services/storage_service.dart
import 'dart:convert';
import 'package:al_zikr/models/presnt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _presetsKey = 'presets';

  static Future<List<PresetModel>> getPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final presetsJson = prefs.getStringList(_presetsKey) ?? [];
    return presetsJson.map((json) => PresetModel.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> savePresets(List<PresetModel> presets) async {
    final prefs = await SharedPreferences.getInstance();
    final presetsJson = presets.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_presetsKey, presetsJson);
  }

  static Future<void> savePreset(PresetModel preset) async {
    final presets = await getPresets();
    presets.add(preset);
    await savePresets(presets);
  }

  static Future<void> deletePreset(int index) async {
    final presets = await getPresets();
    presets.removeAt(index);
    await savePresets(presets);
  }
}
