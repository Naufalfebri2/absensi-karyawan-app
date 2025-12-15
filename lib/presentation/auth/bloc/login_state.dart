abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String email;
  final int userId;
  final String tempToken;

  LoginSuccess({
    required this.email,
    required this.userId,
    required this.tempToken,
  });
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
