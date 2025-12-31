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

      // print('LOGIN RESULT => $result');

      // ===============================
      // ❌ LOGIN FAILED
      // ===============================
      if (result['success'] == false) {
        emit(
          LoginError(
            result['message']?.toString() ?? 'Email or password is invalid',
          ),
        );
        return;
      }

      // ===============================
      // ✅ DIRECT LOGIN (BACKEND KIRIM TOKEN)
      // ===============================
      if (result['token'] != null) {
        emit(
          LoginSuccess(
            token: result['token'].toString(),
            user: result['data'] ?? {},
          ),
        );
        return;
      }

      // ===============================
      // 🔐 OTP FLOW
      // ===============================
      emit(LoginOtpRequired(email: username));
    } catch (_) {
      emit(
        LoginError(
          'Cannot connect to the server. Check your internet connection.',
        ),
      );
    }
  }
}
