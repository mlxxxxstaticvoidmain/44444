import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dioError({
  int? statusCode,
  DioExceptionType type = DioExceptionType.badResponse,
  Object? data = const {'error': 'Invalid API Key'},
}) {
  final options = RequestOptions(path: '/v1/exercises');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('ApiException.fromDio', () {
    test('401 превращается в подсказку про ключ', () {
      final error = ApiException.fromDio(_dioError(statusCode: 401));

      expect(error.statusCode, 401);
      expect(error.isUnauthorized, isTrue);
      expect(error.message, contains('ключ'));
    });

    test('429 объясняет лимит запросов', () {
      final error = ApiException.fromDio(_dioError(statusCode: 429));

      expect(error.message, contains('Лимит'));
      expect(error.isUnauthorized, isFalse);
    });

    test('ошибка соединения помечается как сетевая', () {
      final error = ApiException.fromDio(
        _dioError(type: DioExceptionType.connectionError),
      );

      expect(error.isNetworkError, isTrue);
      expect(error.statusCode, isNull);
    });

    test('таймаут не считается ошибкой ключа', () {
      final error = ApiException.fromDio(
        _dioError(type: DioExceptionType.receiveTimeout),
      );

      expect(error.isNetworkError, isTrue);
      expect(error.isUnauthorized, isFalse);
    });
  });
}
