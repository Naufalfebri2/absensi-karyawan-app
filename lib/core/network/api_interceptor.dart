import 'package:dio/dio.dart';
import '../services/device/local_storage_service.dart';
import '../errors/exceptions.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorageService.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      throw UnauthorizedException();
    }

    throw ServerException(err.message ?? "Unknown error");
  }
}
