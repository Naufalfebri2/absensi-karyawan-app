import 'package:absensi_karyawan_app/config/api_endpoints.dart';
import 'api_service.dart';

class AuthServivce {
  static Future login(String email, String password) {
    return ApiService.post(
      ApiEndpoint.login,
      body: {'email': email, 'password': password},
    );
  }

  static Future verifyOtp(String email, String otp) {
    return ApiService.post(
      ApiEndpoint.verifyOtp,
      body: {'email': email, 'otp': otp},
    );
  }

  static Future getProfile(String token) {
    return ApiService.get(
      ApiEndpoint.profile,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
