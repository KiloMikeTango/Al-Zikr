class ZikrItem {
  final String text;
  final int target;

  ZikrItem({required this.text, required this.target});

  Map<String, dynamic> toMap() => {'text': text, 'target': target};

  factory ZikrItem.fromMap(Map<String, dynamic> map) =>
      ZikrItem(text: map['text'] as String, target: map['target'] as int);
}
