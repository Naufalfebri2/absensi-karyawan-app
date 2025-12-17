import '../../domain/repositories/auth_repo.dart';
import '../datasources/remote/auth_remote.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemote remote;

  AuthRepositoryImpl(this.remote);

  // ================= LOGIN =================
  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) {
    return remote.login(username: username, password: password);
  }

  // ================= OTP VERIFY =================
  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String tempToken, // 🔥 WAJIB
  }) {
    return remote.verifyOtp(
      email: email,
      otp: otp,
      tempToken: tempToken, // 🔥 diteruskan dengan benar
    );
  }

  // ================= FORGOT PASSWORD =================
  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) {
    return remote.forgotPassword(email: email);
  }

  // ================= RESET PASSWORD =================
  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return remote.resetPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
