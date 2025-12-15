abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final String token;
  final Map<String, dynamic> user;

  OtpSuccess({required this.token, required this.user});
}

class OtpError extends OtpState {
  final String message;

  OtpError(this.message);
}
