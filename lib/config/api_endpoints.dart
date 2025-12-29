class ApiEndpoint {
  // ===============================
  // AUTH
  // ===============================
  static const String login = '/login';
  static const String logout = '/logout';
  static const String verifyOtp = '/verify-otp';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ===============================
  // LEAVE (EMPLOYEE)
  // ===============================
  static const String leaves = '/leave-request/store';

  // ===============================
  // LEAVE (MANAGER / HR)
  // ===============================
  static const String leavesPending = '/leave-request/pending';

  static String approveLeave(int id) {
    return '/leave-request/$id/approve';
  }

  static String rejectLeave(int id) {
    return '/leave-request/$id/reject';
  }
}
