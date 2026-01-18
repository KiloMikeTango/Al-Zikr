// lib/models/zikr_item.dart
class ZikrItem {
  final String text;
  final int target;

  ZikrItem({required this.text, required this.target});

  Map<String, dynamic> toJson() => {'text': text, 'target': target};

  factory ZikrItem.fromJson(Map<String, dynamic> json) => ZikrItem(
        text: json['text'],
        target: json['target'],
      );
}
