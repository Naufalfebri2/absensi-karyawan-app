import 'package:absensi_karyawan_app/config/api_endpoints.dart';
import 'api_service.dart';

class AuthServivce {
  // ===============================
  // LOGIN
  // ===============================
  static Future<dynamic> login(String email, String password) {
    return ApiService.post(
      ApiEndpoint.login,
      body: {'email': email, 'password': password},
    );
  }

  // ===============================
  // VERIFY OTP
  // ===============================
  static Future<dynamic> verifyOtp(String email, String otp) {
    return ApiService.post(
      ApiEndpoint.verifyOtp,
      body: {'email': email, 'otp': otp},
    );
  }

  // ===============================
  // FORGOT PASSWORD
  // ===============================
  static Future<dynamic> forgotPassword(String email) {
    return ApiService.post(ApiEndpoint.forgotPassword, body: {'email': email});
  }

  // ===============================
  // PROFILE
  // ===============================
  static Future<dynamic> getProfile(String token) {
    return ApiService.get(
      ApiEndpoint.profile,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  static Future resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return ApiService.post(
      ApiEndpoint.resetPassword,
      body: {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );
  }
}
