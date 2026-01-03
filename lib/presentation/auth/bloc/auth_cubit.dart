import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/device/local_storage_service.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../data/mappers/user_mapper.dart';

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
      final rawUser = await storage.getUser();

      if (token != null &&
          token.isNotEmpty &&
          rawUser != null &&
          rawUser is Map<String, dynamic>) {
        final user = UserMapper.fromJson(rawUser);

        emit(AuthAuthenticated(token: token, user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  /// ===============================
  /// OTP REQUIRED
  /// ===============================
  void requireOtp({required String email}) {
    emit(AuthOtpRequired(email: email));
  }

  /// ===============================
  /// SET AUTH (LOGIN / FULL RESET)
  /// ===============================
  /// Dipakai untuk LOGIN, REGISTER, atau REFRESH SESSION
  Future<void> setAuthenticated({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    emit(AuthLoading());

    try {
      final normalizedUser = _normalizeUser(user);

      final userEntity = UserMapper.fromJson(normalizedUser);

      await storage.saveAccessToken(token);
      await storage.saveUser(normalizedUser);

      emit(AuthAuthenticated(token: token, user: userEntity));
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  /// ===============================
  /// UPDATE USER (PROFILE / AVATAR)
  /// ===============================
  /// 🔥 TIDAK RESET AUTH STATE
  /// 🔥 TIDAK EMIT AuthLoading
  Future<void> updateUser(UserEntity updatedUser) async {
    final currentState = state;

    if (currentState is! AuthAuthenticated) return;

    try {
      final normalizedUser = _normalizeUser(updatedUser.toJson());

      await storage.saveUser(normalizedUser);

      emit(
        AuthAuthenticated(
          token: currentState.token,
          user: UserMapper.fromJson(normalizedUser),
        ),
      );
    } catch (_) {
      // ❗ Tidak logout user hanya karena update profile gagal
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

  /// ===============================
  /// NORMALIZE USER MAP
  /// ===============================
  Map<String, dynamic> _normalizeUser(Map<String, dynamic> user) {
    return {
      ...user,
      'phone_number':
          user['phone_number'] ??
          user['phone'] ??
          user['mobile'] ??
          user['no_hp'] ??
          user['telp'],
    };
  }
}
