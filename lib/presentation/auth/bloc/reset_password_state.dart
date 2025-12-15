abstract class ResetPasswordState {
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  const ResetPasswordError(this.message);
}
