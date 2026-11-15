import 'dart:convert';

class Exercise {
  const Exercise({
    required this.name,
    required this.muscle,
    required this.type,
    required this.difficulty,
    required this.instructions,
    this.equipments = const [],
    this.safetyInfo,
    this.imageUrl,
  });

  final String name;
  final String muscle;
  final String type;
  final String difficulty;
  final String instructions;
  final List<String> equipments;
  final String? safetyInfo;
  final String? imageUrl;

  String get id => '${muscle}_$name'.toLowerCase();

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: _asString(json['name'], fallback: 'Без названия'),
      muscle: _asString(json['muscle']),
      type: _asString(json['type']),
      difficulty: _asString(json['difficulty']),
      instructions: _asString(json['instructions']),
      equipments: _asStringList(json['equipments'] ?? json['equipment']),
      safetyInfo: _asNullableString(json['safety_info']),
      imageUrl: _firstString(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'muscle': muscle,
      'type': type,
      'difficulty': difficulty,
      'instructions': instructions,
      'equipments': equipments,
      if (safetyInfo != null) 'safety_info': safetyInfo,
      if (imageUrl != null) 'images': [imageUrl],
    };
  }

  String encode() => jsonEncode(toJson());

  static Exercise decode(String source) {
    return Exercise.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  List<String> get steps {
    final normalized = instructions.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty) return const [];

    final parts = normalized.split(RegExp(r'(?<=[.!?])\s+'));
    return parts
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Exercise && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Exercise($name, $muscle)';
}

String _asString(Object? value, {String fallback = ''}) {
  if (value is String) return value.trim();
  if (value == null) return fallback;
  return value.toString();
}

String? _asNullableString(Object? value) {
  final text = _asString(value);
  return text.isEmpty ? null : text;
}

List<String> _asStringList(Object? value) {
  if (value is List) {
    return value
        .map((item) => _asString(item))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
  if (value is String && value.trim().isNotEmpty) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
  return const [];
}

String? _firstString(Object? value) {
  if (value is List && value.isNotEmpty) {
    final first = value.first;
    if (first is String && first.trim().isNotEmpty) return first;
  }
  if (value is String && value.trim().isNotEmpty) return value;
  return null;
}
