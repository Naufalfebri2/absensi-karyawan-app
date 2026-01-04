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
      
      // 🔥 DEBUG LOGGING
      print('🔍 [AuthCubit] checkAuthStatus called');
      print('🔍 [AuthCubit] Token from storage: ${token != null ? "EXISTS (${token.length} chars)" : "NULL"}');
      print('🔍 [AuthCubit] User from storage: ${rawUser != null ? "EXISTS" : "NULL"}');

      if (token != null &&
          token.isNotEmpty &&
          rawUser != null &&
          rawUser is Map<String, dynamic>) {
        final user = UserMapper.fromJson(rawUser);

        emit(AuthAuthenticated(token: token, user: user));
        
        // 🔥 DEBUG LOGGING
        print('🔍 [AuthCubit] User authenticated: ${user.name}');
      } else {
        emit(AuthUnauthenticated());
        
        // 🔥 DEBUG LOGGING
        print('🔍 [AuthCubit] No valid session found');
      }
    } catch (e) {
      // 🔥 DEBUG LOGGING
      print('🔴 [AuthCubit] Error in checkAuthStatus: $e');
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
      // 🔥 DEBUG LOGGING
      print('🔍 [AuthCubit] setAuthenticated called');
      print('🔍 [AuthCubit] Token length: ${token.length}');
      print('🔍 [AuthCubit] Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      print('🔍 [AuthCubit] User data: $user');

      final normalizedUser = _normalizeUser(user);

      final userEntity = UserMapper.fromJson(normalizedUser);

      await storage.saveAccessToken(token);
      await storage.saveUser(normalizedUser);
      
      // 🔥 DEBUG LOGGING - Verify save
      final savedToken = await storage.getAccessToken();
      print('🔍 [AuthCubit] Token saved successfully: ${savedToken != null && savedToken.isNotEmpty}');

      emit(AuthAuthenticated(token: token, user: userEntity));
    } catch (e) {
      // 🔥 DEBUG LOGGING
      print('🔴 [AuthCubit] Error in setAuthenticated: $e');
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
