abstract class AuthRepo {
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Map<String, dynamic>> forgotPassword({required String email});

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  });
}
