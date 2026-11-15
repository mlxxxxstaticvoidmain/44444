import 'package:flutter_application_1/core/storage/preferences_service.dart';
import 'package:flutter_application_1/data/models/exercise.dart';
import 'package:flutter_application_1/data/repositories/favorites_repository.dart';
import 'package:flutter_application_1/data/repositories/workout_repository.dart';
import 'package:flutter_application_1/features/favorites/favorites_controller.dart';
import 'package:flutter_application_1/features/plan/workout_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _exercise = Exercise(
  name: 'Barbell Squat',
  muscle: 'quadriceps',
  type: 'strength',
  difficulty: 'intermediate',
  instructions: 'Stand with the bar on your upper back. Squat down and drive up.',
  equipments: ['barbell'],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('избранное сохраняется между запусками', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesService.create();

    final favorites = FavoritesController(
      FavoritesRepository(preferences),
    );
    expect(favorites.toggle(_exercise), isTrue);
    expect(favorites.count, 1);
    await pumpEventQueue();

    final restored = FavoritesController(
      FavoritesRepository(preferences),
    );
    expect(restored.isFavorite(_exercise.id), isTrue);

    restored.remove(_exercise.id);
    await pumpEventQueue();

    final empty = FavoritesController(FavoritesRepository(preferences));
    expect(empty.count, 0);
  });

  test('план тренировки хранит отметки о выполнении', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesService.create();

    final workout = WorkoutController(WorkoutRepository(preferences));
    expect(workout.toggle(_exercise), isTrue);
    workout.toggleDone(_exercise.id);
    expect(workout.doneCount, 1);
    expect(workout.progress, 1);
    await pumpEventQueue();

    final restored = WorkoutController(WorkoutRepository(preferences));
    expect(restored.count, 1);
    expect(restored.entries.single.isDone, isTrue);
    expect(restored.contains(_exercise.id), isTrue);

    expect(restored.toggle(_exercise), isFalse);
    expect(restored.isEmpty, isTrue);
  });

  test('ключ API сохраняется и очищается', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesService.create();

    expect(preferences.apiKey, isNull);
    await preferences.setApiKey('  secret-key-123  ');
    expect(preferences.apiKey, 'secret-key-123');

    await preferences.setApiKey('   ');
    expect(preferences.apiKey, isNull);
  });
}
