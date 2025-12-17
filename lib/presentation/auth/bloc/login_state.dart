abstract class LoginState {}

/// ===============================
/// INITIAL
/// ===============================
class LoginInitial extends LoginState {}

/// ===============================
/// LOADING
/// ===============================
class LoginLoading extends LoginState {}

/// ===============================
/// LOGIN VALID → OTP REQUIRED
/// ===============================
class LoginOtpRequired extends LoginState {
  final String email;
  final String tempToken;

  LoginOtpRequired({required this.email, required this.tempToken});
}

/// ===============================
/// ERROR
/// ===============================
class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
