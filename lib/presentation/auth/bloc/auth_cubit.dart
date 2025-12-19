import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/device/local_storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalStorageService storage;

  AuthCubit(this.storage) : super(AuthInitial());

  /// ===============================
  /// INIT / CHECK SESSION
  /// ===============================
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final token = await storage.getAccessToken();
      final user = await storage.getUser();

      if (token != null && token.isNotEmpty && user != null) {
        emit(AuthAuthenticated(token: token, user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  /// ===============================
  /// OTP REQUIRED (SEBELUM LOGIN)
  /// ===============================
  void requireOtp({required String email}) {
    emit(AuthOtpRequired(email: email));
  }

  /// ===============================
  /// SET AUTH AFTER OTP SUCCESS
  /// ===============================
  Future<void> setAuthenticated({
    required String token,
    required dynamic user,
  }) async {
    emit(AuthLoading());

    try {
      await storage.saveAccessToken(token);
      await storage.saveUser(user);

      emit(AuthAuthenticated(token: token, user: user));
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await storage.clear();
    } catch (_) {}

    emit(AuthUnauthenticated());
  }
}
