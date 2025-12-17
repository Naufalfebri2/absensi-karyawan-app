import '../../repositories/auth_repo.dart';

class OtpVerify {
  final AuthRepo repo;

  OtpVerify(this.repo);

  Future<Map<String, dynamic>> call({
    required String email,
    required String otp,
    required String tempToken, // 🔥 WAJIB
  }) async {
    return await repo.verifyOtp(
      email: email,
      otp: otp,
      tempToken: tempToken, // 🔥 diteruskan ke backend
    );
  }
}
