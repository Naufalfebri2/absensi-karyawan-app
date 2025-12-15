import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../config/api_endpoints.dart';

class AuthRemote {
  final Dio dio;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AuthRemote(this.dio);

  // ===============================
  // LOGIN
  // ===============================
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      String deviceId = 'unknown';
      String deviceName = 'unknown';

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
        deviceName = iosInfo.name;
      }

      final response = await dio.post(
        ApiEndpoint.login,
        data: {
          "email": username,
          "password": password,
          "device_id": deviceId,
          "device_name": deviceName,
        },
      );

      return response.data;
    } on DioException catch (e) {
      // Standardisasi error agar Cubit rapi
      return {
        "success": false,
        "message": e.response?.data['message'] ?? "Gagal terhubung ke server",
      };
    } catch (_) {
      return {"success": false, "message": "Terjadi kesalahan pada aplikasi"};
    }
  }

  // ===============================
  // VERIFY OTP
  // ===============================
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoint.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      return response.data;
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data['message'] ?? "Verifikasi OTP gagal",
      };
    } catch (_) {
      return {"success": false, "message": "Terjadi kesalahan pada aplikasi"};
    }
  }
}
