import '../../core/services/auth_servivce.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  // ================= LOGIN =================
  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    return await AuthServivce.login(username, password);
  }

  // ================= OTP VERIFY =================
  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String tempToken, // 🔥 WAJIB
  }) async {
    return await AuthServivce.verifyOtp(
      email: email,
      otp: otp,
      tempToken: tempToken, // 🔥 diteruskan
    );
  }

  // ================= FORGOT PASSWORD =================
  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await AuthServivce.forgotPassword(email);
  }

  // ================= RESET PASSWORD =================
  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await AuthServivce.resetPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
