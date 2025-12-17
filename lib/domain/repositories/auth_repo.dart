abstract class AuthRepo {
  // ================= LOGIN =================
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  });

  // ================= OTP VERIFY =================
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });

  // ================= FORGOT PASSWORD =================
  Future<Map<String, dynamic>> forgotPassword({required String email});

  // ================= RESET PASSWORD =================
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  });
}
