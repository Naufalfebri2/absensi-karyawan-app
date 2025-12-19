import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/login_user.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser loginUser;

  LoginCubit(this.loginUser) : super(LoginInitial());

  Future<void> submitLogin({
    required String username,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final Map<String, dynamic> result = await loginUser(
        username: username,
        password: password,
      );

      print('LOGIN RESULT => $result');

      // ===============================
      // OTP REQUIRED
      // ===============================
      if (result['require_otp'] == true) {
        emit(LoginOtpRequired(email: username));
        return;
      }

      // ===============================
      // LOGIN FAILED
      // ===============================
      emit(
        LoginError(
          result['message']?.toString() ?? 'Email atau password tidak valid',
        ),
      );
    } catch (_) {
      emit(
        LoginError(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        ),
      );
    }
  }
}
