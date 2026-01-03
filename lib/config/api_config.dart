class ApiConfig {
  ApiConfig._();

  /// ===============================
  /// HTTP API BASE URL
  /// ===============================
  static const String baseUrl = 'http://10.51.215.119:8000/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
