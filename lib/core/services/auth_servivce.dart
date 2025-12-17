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
  // VERIFY OTP (LOGIN / FORGOT PASSWORD)
  // ===============================
  static Future<dynamic> verifyOtp({
    required String email,
    required String otp,
    required String tempToken, // 🔥 WAJIB
  }) {
    return ApiService.post(
      ApiEndpoint.verifyOtp,
      body: {
        'email': email,
        'otp': otp,
        'temp_token': tempToken, // 🔥 dikirim ke backend
      },
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

  // ===============================
  // RESET PASSWORD
  // ===============================
  static Future<dynamic> resetPassword({
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
