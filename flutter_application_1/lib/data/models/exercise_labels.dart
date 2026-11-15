import 'exercise.dart';

abstract final class ExerciseLabels {
  static const Map<String, String> _muscles = {
    'abdominals': 'Пресс',
    'abductors': 'Отводящие мышцы бедра',
    'adductors': 'Приводящие мышцы бедра',
    'biceps': 'Бицепс',
    'calves': 'Икры',
    'chest': 'Грудь',
    'forearms': 'Предплечья',
    'glutes': 'Ягодицы',
    'hamstrings': 'Бицепс бедра',
    'lats': 'Широчайшие',
    'lower_back': 'Поясница',
    'middle_back': 'Средняя спина',
    'neck': 'Шея',
    'quadriceps': 'Квадрицепс',
    'traps': 'Трапеции',
    'triceps': 'Трицепс',
  };

  static const List<String> muscleKeys = [
    'chest',
    'lats',
    'middle_back',
    'lower_back',
    'traps',
    'neck',
    'abdominals',
    'biceps',
    'triceps',
    'forearms',
    'quadriceps',
    'hamstrings',
    'glutes',
    'calves',
    'abductors',
    'adductors',
  ];

  static const Map<String, String> _types = {
    'cardio': 'кардио',
    'olympic_weightlifting': 'тяжёлая атлетика',
    'plyometrics': 'плиометрика',
    'powerlifting': 'пауэрлифтинг',
    'strength': 'силовое',
    'stretching': 'растяжка',
    'strongman': 'стронгмен',
  };

  static const List<String> typeKeys = [
    'strength',
    'cardio',
    'stretching',
    'plyometrics',
    'powerlifting',
    'olympic_weightlifting',
    'strongman',
  ];

  static const Map<String, String> _difficulties = {
    'beginner': 'новичок',
    'intermediate': 'средний',
    'expert': 'профи',
  };

  static const List<String> difficultyKeys = [
    'beginner',
    'intermediate',
    'expert',
  ];

  static const Map<String, String> _equipment = {
    'barbell': 'штанга',
    'dumbbell': 'гантель',
    'dumbbells': 'гантели',
    'kettlebell': 'гиря',
    'kettlebells': 'гири',
    'body only': 'без инвентаря',
    'bodyweight': 'свой вес',
    'bench': 'скамья',
    'flat bench': 'горизонтальная скамья',
    'incline bench': 'наклонная скамья',
    'decline bench': 'скамья с отрицательным наклоном',
    'e-z curl bar': 'EZ-гриф',
    'ez bar': 'EZ-гриф',
    'ez-curl bar': 'EZ-гриф',
    'cable': 'блок',
    'cable machine': 'блочный тренажёр',
    'machine': 'тренажёр',
    'pull-up bar': 'турник',
    'pull up bar': 'турник',
    'dip bars / parallel bars': 'брусья',
    'dip bars': 'брусья',
    'exercise mat': 'коврик',
    'mat': 'коврик',
    'resistance band': 'резиновая лента',
    'bands': 'резиновые ленты',
    'medicine ball': 'медбол',
    'stability ball': 'фитбол',
    'jump rope': 'скакалка',
    'box': 'бокс',
    'other': 'другое',
  };

  static String muscle(String raw) => _muscles[raw] ?? _fallback(raw);

  static String type(String raw) => _types[raw] ?? _fallback(raw);

  static String difficulty(String raw) =>
      _difficulties[raw] ?? _fallback(raw);

  static String equipment(String raw) =>
      _equipment[raw.toLowerCase()] ?? _fallback(raw);

  static String _fallback(String raw) {
    if (raw.isEmpty) return '';
    return raw.replaceAll('_', ' ');
  }

  static String get muscleSummary => muscleKeys.map(muscle).join(', ');

  static String metaLine(Exercise exercise) {
    return [
      muscle(exercise.muscle),
      type(exercise.type),
    ].where((part) => part.isNotEmpty).join(', ');
  }

  static String equipmentLine(Exercise exercise, {int limit = 2}) {
    if (exercise.equipments.isEmpty) return '';
    final names = exercise.equipments
        .take(limit)
        .map(equipment)
        .where((name) => name.isNotEmpty)
        .toList();
    final rest = exercise.equipments.length - names.length;
    if (rest > 0) names.add('+$rest');
    return names.join(', ');
  }
}
