import 'package:absensi_karyawan_app/config/api_endpoints.dart';
import 'api_service.dart';

class AuthService {
  // ===============================
  // LOGIN
  // ===============================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await ApiService.post(
      ApiEndpoint.login,
      body: {'email': email, 'password': password},
    );

    return Map<String, dynamic>.from(response);
  }

  // ===============================
  // VERIFY OTP
  // ===============================
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await ApiService.post(
      ApiEndpoint.verifyOtp,
      body: {'email': email, 'otp': otp},
    );

    return Map<String, dynamic>.from(response);
  }

  // ===============================
  // FORGOT PASSWORD
  // ===============================
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await ApiService.post(
      ApiEndpoint.forgotPassword,
      body: {'email': email},
    );

    return Map<String, dynamic>.from(response);
  }

  // ===============================
  // PROFILE
  // ===============================
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await ApiService.get(
      ApiEndpoint.profile,
      headers: {'Authorization': 'Bearer $token'},
    );

    return Map<String, dynamic>.from(response);
  }

  // ===============================
  // RESET PASSWORD
  // ===============================
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiService.post(
      ApiEndpoint.resetPassword,
      body: {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );

    return Map<String, dynamic>.from(response);
  }
}
