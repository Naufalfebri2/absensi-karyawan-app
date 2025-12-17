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

  LoginOtpRequired({required this.email});
}

/// ===============================
/// ERROR
/// ===============================
class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
