import '../../core/services/auth_servivce.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    return await AuthServivce.login(username, password);
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await AuthServivce.verifyOtp(email, otp);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await AuthServivce.forgotPassword(email);
  }

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
