class ApiConfig {
  ApiConfig._();

  /// ===============================
  /// HTTP API BASE URL
  /// ===============================
  static const String baseUrl = 'http://202.10.35.18:8003/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
