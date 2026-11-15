import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';

Dio createDio(AuthInterceptor authInterceptor) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const {'Accept': 'application/json'},
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(authInterceptor);

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 110,
      ),
    );
  }

  return dio;
}
