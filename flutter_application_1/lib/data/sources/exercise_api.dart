import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/di/injection.dart';
import '../../core/network/api_exception.dart';
import '../models/exercise.dart';
import '../models/exercise_query.dart';

class ExerciseApi {
  Future<List<Exercise>> fetchExercises(ExerciseQuery query) async {
    try {
      final response = await getIt<Dio>().get(
        AppConfig.exercisesPath,
        queryParameters: query.toQueryParameters(),
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Exercise.fromJson(json as Map<String, dynamic>))
          .toList();
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
      await getIt<Dio>().get(
        AppConfig.exercisesPath,
        queryParameters: const {'muscle': 'biceps'},
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
