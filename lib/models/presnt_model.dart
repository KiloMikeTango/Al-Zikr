// lib/models/preset_model.dart
import 'package:al_zikr/models/zikr_items.dart';

class PresetModel {
  final String name;
  final List<ZikrItem> zikrs;

  PresetModel({required this.name, required this.zikrs});

  Map<String, dynamic> toJson() => {
        'name': name,
        'zikrs': zikrs.map((z) => z.toJson()).toList(),
      };

  factory PresetModel.fromJson(Map<String, dynamic> json) => PresetModel(
        name: json['name'],
        zikrs: (json['zikrs'] as List).map((z) => ZikrItem.fromJson(z)).toList(),
      );
}
