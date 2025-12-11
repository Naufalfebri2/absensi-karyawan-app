import 'package:dio/dio.dart';

class DioClient {
  // Singleton Instance
  DioClient._internal();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-api-url.com/api", // GANTI BASE URL DI SINI
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  static Dio get instance => _dio;

  // Tambahkan interceptor jika perlu
  static void addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("[DIO REQUEST] ${options.method} → ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("[DIO RESPONSE] ${response.statusCode}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("[DIO ERROR] ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }
}
