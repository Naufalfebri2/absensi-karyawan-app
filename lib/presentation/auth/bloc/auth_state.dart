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
  final dynamic user;

  const AuthAuthenticated({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

/// ===============================
/// UNAUTHENTICATED STATE
/// ===============================
class AuthUnauthenticated extends AuthState {}
