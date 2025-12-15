import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:absensi_karyawan_app/config/api_config.dart';
import 'package:absensi_karyawan_app/core/services/device/local_storage_service.dart';

class DioClient {
  DioClient._internal();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  /// ===============================
  /// SETUP INTERCEPTORS
  /// ===============================
  static void setupInterceptors(LocalStorageService storage) {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        // ===============================
        // REQUEST
        // ===============================
        onRequest: (options, handler) async {
          final token = await storage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            debugPrint(
              '[DIO REQUEST] ${options.method} ${options.baseUrl}${options.path}',
            );
            debugPrint('[DIO DATA] ${options.data}');
          }

          return handler.next(options);
        },

        // ===============================
        // RESPONSE
        // ===============================
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[DIO RESPONSE] ${response.statusCode} ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },

        // ===============================
        // ERROR
        // ===============================
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[DIO ERROR] ${error.response?.statusCode} '
              '${error.requestOptions.path} '
              '${error.message}',
            );
          }
          return handler.next(error);
        },
      ),
    );
  }
}
