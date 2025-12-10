import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  // Data user
  final int? userId;
  final int? employeeId;
  final String? fullName;
  final String? email;
  final String? role;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.userId,
    this.employeeId,
    this.fullName,
    this.email,
    this.role,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    int? userId,
    int? employeeId,
    String? fullName,
    String? email,
    String? role,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage ?? this.errorMessage,
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isAuthenticated,
    errorMessage,
    userId,
    employeeId,
    fullName,
    email,
    role,
  ];
}
