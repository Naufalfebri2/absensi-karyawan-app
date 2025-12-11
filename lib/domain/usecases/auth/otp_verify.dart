import '../../repositories/auth_repo.dart';

class OtpVerify {
  final AuthRepo repo;

  OtpVerify(this.repo);

  Future<Map<String, dynamic>> call({
    required int userId,
    required String otp,
    required String tempToken,
  }) async {
    return await repo.verifyOtp(userId: userId, otp: otp, tempToken: tempToken);
  }
}
