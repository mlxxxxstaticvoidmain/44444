import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
  });

  final String message;
  final int? statusCode;
  final bool isNetworkError;

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          'API Ninjas не ответил вовремя. Проверьте соединение и повторите запрос.',
          isNetworkError: true,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          'Нет соединения с интернетом. Проверьте сеть и повторите запрос.',
          isNetworkError: true,
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          'Сертификат сервера не прошёл проверку.',
          isNetworkError: true,
        );
      case DioExceptionType.cancel:
        return const ApiException('Запрос отменён.');
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        break;
    }

    final status = error.response?.statusCode;
    if (status == null) {
      return const ApiException(
        'Не удалось подключиться к API Ninjas. Проверьте интернет и повторите.',
        isNetworkError: true,
      );
    }

    switch (status) {
      case 400:
        return ApiException(
          'API отклонил параметры запроса. Измените фильтры и попробуйте снова.',
          statusCode: status,
        );
      case 401:
      case 403:
        return ApiException(
          'API-ключ не принят. Проверьте ключ API Ninjas в настройках.',
          statusCode: status,
        );
      case 404:
        return ApiException(
          'Эндпоинт не найден. Возможно, API изменился.',
          statusCode: status,
        );
      case 429:
        return ApiException(
          'Лимит запросов API Ninjas исчерпан. Ключ действует, но месячная квота закончилась.',
          statusCode: status,
        );
      default:
        if (status >= 500) {
          return ApiException(
            'Сервис API Ninjas временно недоступен. Попробуйте позже.',
            statusCode: status,
          );
        }
        return ApiException(
          'Запрос завершился с ошибкой $status.',
          statusCode: status,
        );
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
