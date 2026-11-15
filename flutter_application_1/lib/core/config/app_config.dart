abstract final class AppConfig {
  static const String appName = 'Атлас упражнений';
  static const String version = '1.0.0';

  static const String baseUrl = 'https://api.api-ninjas.com';
  static const String exercisesPath = '/v1/exercises';

  static const String apiKeyHeader = 'X-Api-Key';
  static const String registerUrl = 'https://api-ninjas.com/register';
  static const String docsUrl = 'https://api-ninjas.com/api/exercises';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const int maxResultsPerRequest = 5;
}
