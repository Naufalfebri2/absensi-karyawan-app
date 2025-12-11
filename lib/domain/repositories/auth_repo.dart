abstract class AuthRepo {
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    required String tempToken,
  });
}
