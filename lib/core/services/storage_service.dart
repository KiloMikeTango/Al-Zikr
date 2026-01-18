import 'dart:convert';
import 'package:al_zikr/models/preset_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _presetsKey = 'presets';

  static Future<List<PresetModel>> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_presetsKey) ?? [];
    return list
        .map((s) => PresetModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> savePresets(List<PresetModel> presets) async {
    final prefs = await SharedPreferences.getInstance();
    final list =
        presets.map((p) => jsonEncode(p.toJson())).toList(growable: false);
    await prefs.setStringList(_presetsKey, list);
  }
}
