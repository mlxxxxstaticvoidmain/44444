import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../models/exercise.dart';
import '../models/exercise_query.dart';

class ExerciseApi {
  ExerciseApi(this._dio);

  final Dio _dio;

  Future<List<Exercise>> fetchExercises(ExerciseQuery query) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        AppConfig.exercisesPath,
        queryParameters: query.toQueryParameters(),
      );

      final data = response.data ?? const <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Exercise.fromJson)
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'Не удалось разобрать ответ API Ninjas.',
        isNetworkError: false,
      );
    }
  }

  Future<void> ping() async {
    try {
      await _dio.get<List<dynamic>>(
        AppConfig.exercisesPath,
        queryParameters: const {'muscle': 'biceps'},
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
