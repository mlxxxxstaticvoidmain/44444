import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/preferences_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._preferences);

  final PreferencesService _preferences;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final apiKey = _preferences.apiKey;
    if (apiKey != null && apiKey.isNotEmpty) {
      options.headers[AppConfig.apiKeyHeader] = apiKey;
    }
    handler.next(options);
  }
}
