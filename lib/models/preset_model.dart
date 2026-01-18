import 'package:al_zikr/models/zikr_items.dart';


class PresetModel {
  final String name;
  final List<ZikrItem> zikrs;

  PresetModel({required this.name, required this.zikrs});

  Map<String, dynamic> toJson() => {
        'name': name,
        'zikrs': zikrs.map((e) => e.toMap()).toList(),
      };

  factory PresetModel.fromJson(Map<String, dynamic> json) => PresetModel(
        name: json['name'] as String,
        zikrs: (json['zikrs'] as List)
            .map((e) => ZikrItem.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
