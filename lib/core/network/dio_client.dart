import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import 'api_interceptor.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(ApiInterceptor(dio));
    return dio;
  }
}
