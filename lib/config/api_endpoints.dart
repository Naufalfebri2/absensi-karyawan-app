class ApiEndpoint {
  static const String baseUrl = "http://202.10.35.18:8002/api";

  // Auth
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String profile = "$baseUrl/profile";
}
