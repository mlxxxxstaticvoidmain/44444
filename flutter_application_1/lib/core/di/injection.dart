import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/sources/exercise_api.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../features/plan/workout_controller.dart';
import '../../features/search/exercise_search_controller.dart';
import '../../features/settings/settings_controller.dart';
import '../../features/settings/theme_controller.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_factory.dart';
import '../storage/preferences_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<PreferencesService>()) return;

  final preferences = await PreferencesService.create();

  getIt
    ..registerSingleton<PreferencesService>(preferences)
    ..registerSingleton<ThemeController>(ThemeController(preferences))
    ..registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(getIt<PreferencesService>()),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(getIt<AuthInterceptor>()),
    )
    ..registerLazySingleton<ExerciseApi>(
      () => ExerciseApi(getIt<Dio>()),
    )
    ..registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepository(getIt<ExerciseApi>()),
    )
    ..registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepository(getIt<PreferencesService>()),
    )
    ..registerLazySingleton<WorkoutRepository>(
      () => WorkoutRepository(getIt<PreferencesService>()),
    )
    ..registerLazySingleton<FavoritesController>(
      () => FavoritesController(getIt<FavoritesRepository>()),
    )
    ..registerLazySingleton<WorkoutController>(
      () => WorkoutController(getIt<WorkoutRepository>()),
    )
    ..registerLazySingleton<SettingsController>(
      () => SettingsController(
        getIt<PreferencesService>(),
        getIt<ExerciseRepository>(),
      ),
    )
    ..registerLazySingleton<ExerciseSearchController>(
      () => ExerciseSearchController(getIt<ExerciseRepository>()),
    );
}
