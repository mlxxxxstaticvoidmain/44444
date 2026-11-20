import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/network/auth_interceptor.dart';
import 'core/storage/preferences_service.dart';
import 'data/repositories/exercise_repository.dart';
import 'data/repositories/favorites_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'data/sources/exercise_api.dart';
import 'features/favorites/favorites_controller.dart';
import 'features/plan/workout_controller.dart';
import 'features/search/exercise_search_controller.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupService();
  runApp(const AtlasApp());
}

Future<void> setupService() async {
  if (getIt.isRegistered<PreferencesService>()) return;

  final preferences = await PreferencesService.create();
  getIt.registerSingleton<PreferencesService>(preferences);
  getIt.registerSingleton<ThemeController>(ThemeController(preferences));

  final authInterceptor = AuthInterceptor(preferences);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const {'Accept': 'application/json'},
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.addAll([
    authInterceptor,
    PrettyDioLogger(),
  ]);

  getIt.registerSingleton<Dio>(dio);
  getIt.registerLazySingleton<ExerciseApi>(() => ExerciseApi());
  getIt.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepository(getIt<ExerciseApi>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepository(getIt<PreferencesService>()),
  );
  getIt.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepository(getIt<PreferencesService>()),
  );
  getIt.registerLazySingleton<FavoritesController>(
    () => FavoritesController(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<WorkoutController>(
    () => WorkoutController(getIt<WorkoutRepository>()),
  );
  getIt.registerLazySingleton<SettingsController>(
    () => SettingsController(
      getIt<PreferencesService>(),
      getIt<ExerciseRepository>(),
    ),
  );
  getIt.registerLazySingleton<ExerciseSearchController>(
    () => ExerciseSearchController(getIt<ExerciseRepository>()),
  );
}
