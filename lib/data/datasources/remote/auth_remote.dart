import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../config/api_endpoints.dart';

class AuthRemote {
  final Dio dio;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AuthRemote(this.dio);

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    print(password);

    String deviceId = 'unknown';
    String deviceName = 'unknown';
    final androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
    deviceName = '${androidInfo.brand} ${androidInfo.model}';
    // if (Platform.isAndroid) {
    //   final androidInfo = await deviceInfo.androidInfo;
    //   deviceId = androidInfo.id;
    //   deviceName = '${androidInfo.brand} ${androidInfo.model}';
    // } else if (Platform.isIOS) {
    //   final iosInfo = await deviceInfo.iosInfo;
    //   deviceId = iosInfo.identifierForVendor ?? 'unknown';
    //   deviceName = iosInfo.name ?? 'iPhone';
    // }
    
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
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await dio.post(
      ApiEndpoint.verifyOtp,
      data: {"email": email, "otp": otp},
    );

    return response.data;
  }
}
