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

/// ===============================
/// LOGIN SUCCESS (DIRECT LOGIN)
/// ===============================
class LoginSuccess extends LoginState {
  final String token;
  final dynamic user;

  LoginSuccess({required this.token, required this.user});
}
