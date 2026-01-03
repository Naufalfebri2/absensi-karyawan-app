class ApiConfig {
  static const String baseUrl = 'http://202.10.35.18:8003/api';
  // static const String baseUrl = 'http://10.51.215.119:8000/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
