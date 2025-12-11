import 'package:dio/dio.dart';

class AuthRemote {
  final Dio dio;

  AuthRemote(this.dio);

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/auth/login',
      data: {"username": username, "password": password},
    );
    return response.data;
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    required String tempToken,
  }) async {
    final response = await dio.post(
      '/api/auth/verify-otp',
      data: {"user_id": userId, "otp": otp, "temp_token": tempToken},
    );
    return response.data;
  }
}
