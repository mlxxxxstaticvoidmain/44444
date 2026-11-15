import 'package:flutter_application_1/core/utils/formatters.dart';
import 'package:flutter_application_1/data/models/exercise.dart';
import 'package:flutter_application_1/data/models/exercise_labels.dart';
import 'package:flutter_application_1/data/models/exercise_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise.fromJson', () {
    test('разбирает полный ответ API', () {
      final exercise = Exercise.fromJson(const {
        'name': 'Incline Hammer Curls',
        'type': 'strength',
        'muscle': 'biceps',
        'difficulty': 'beginner',
        'instructions':
            'Seat yourself on an incline bench. Curl the dumbbells up. Lower slowly.',
        'equipments': ['dumbbells', 'incline bench'],
        'safety_info': 'Keep your back against the bench.',
        'images': ['https://example.com/1.png', 'https://example.com/2.png'],
      });

      expect(exercise.name, 'Incline Hammer Curls');
      expect(exercise.muscle, 'biceps');
      expect(exercise.equipments, ['dumbbells', 'incline bench']);
      expect(exercise.safetyInfo, isNotNull);
      expect(exercise.imageUrl, 'https://example.com/1.png');
      expect(exercise.steps.length, 3);
      expect(ExerciseLabels.muscle(exercise.muscle), 'Бицепс');
    });

    test('поддерживает equipments строкой и пустые поля', () {
      final exercise = Exercise.fromJson(const {
        'name': 'Push-up',
        'equipments': 'body only, mat',
      });

      expect(exercise.equipments, ['body only', 'mat']);
      expect(exercise.safetyInfo, isNull);
      expect(exercise.steps, isEmpty);
      expect(exercise.difficulty, isEmpty);
    });

    test('переживает сериализацию в локальное хранилище', () {
      const source = Exercise(
        name: 'Barbell Bench Press',
        muscle: 'chest',
        type: 'strength',
        difficulty: 'intermediate',
        instructions: 'Lie on a flat bench. Lower the bar to your chest.',
        equipments: ['barbell', 'flat bench'],
        safetyInfo: 'Use a spotter.',
      );

      final restored = Exercise.decode(source.encode());

      expect(restored, source);
      expect(restored.name, source.name);
      expect(restored.equipments, source.equipments);
      expect(restored.safetyInfo, source.safetyInfo);
    });
  });

  group('ExerciseQuery', () {
    test('не отправляет пустые и слишком короткие параметры', () {
      const query = ExerciseQuery(name: ' b ', muscle: null);

      expect(query.toQueryParameters(), isEmpty);
      expect(query.isEmpty, isTrue);
    });

    test('собирает параметры запроса', () {
      const query = ExerciseQuery(
        name: 'press',
        muscle: 'chest',
        difficulty: 'beginner',
      );

      expect(query.toQueryParameters(), {
        'name': 'press',
        'muscle': 'chest',
        'difficulty': 'beginner',
      });
      expect(query.activeFilters, 3);
    });
  });

  test('русские формы множественного числа', () {
    expect(exercisesCount(1), '1 упражнение');
    expect(exercisesCount(3), '3 упражнения');
    expect(exercisesCount(5), '5 упражнений');
    expect(exercisesCount(21), '21 упражнение');
  });
}
