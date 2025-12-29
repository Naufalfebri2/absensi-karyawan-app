part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// ===============================
/// INITIAL STATE
/// ===============================
class AuthInitial extends AuthState {}

/// ===============================
/// LOADING STATE
/// ===============================
class AuthLoading extends AuthState {}

/// ===============================
/// AUTHENTICATED STATE
/// ===============================
class AuthAuthenticated extends AuthState {
  final String token;
  final UserEntity user; // ✅ FIX: JANGAN dynamic

  const AuthAuthenticated({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

/// ===============================
/// UNAUTHENTICATED STATE
/// ===============================
class AuthUnauthenticated extends AuthState {}

/// ===============================
/// OTP REQUIRED STATE
/// ===============================
class AuthOtpRequired extends AuthState {
  final String email;

  const AuthOtpRequired({required this.email});

  @override
  List<Object?> get props => [email];
}
