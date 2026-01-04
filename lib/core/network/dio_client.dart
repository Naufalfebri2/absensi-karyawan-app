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

          // 🔥 DEBUG LOGGING
          if (kDebugMode) {
            debugPrint('🔍 [DIO] Token from storage: ${token != null ? "EXISTS (${token.length} chars)" : "NULL"}');
          }

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            
            if (kDebugMode) {
              debugPrint('🔍 [DIO] Authorization header set');
            }
          } else {
            if (kDebugMode) {
              debugPrint('⚠️ [DIO] No token available - request will be unauthenticated');
            }
          }

          if (kDebugMode) {
            debugPrint(
              '[DIO REQUEST] ${options.method} ${options.baseUrl}${options.path}',
            );
            debugPrint('[DIO HEADERS] ${options.headers}');
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
            
            // 🔥 DETAILED 401 ERROR LOGGING
            if (error.response?.statusCode == 401) {
              debugPrint('🔴 [DIO] 401 UNAUTHORIZED ERROR');
              debugPrint('🔴 [DIO] Request URL: ${error.requestOptions.uri}');
              debugPrint('🔴 [DIO] Request Headers: ${error.requestOptions.headers}');
              debugPrint('🔴 [DIO] Response: ${error.response?.data}');
            }
          }
          
          return handler.next(error);
        },
      ),
    );
  }
}
