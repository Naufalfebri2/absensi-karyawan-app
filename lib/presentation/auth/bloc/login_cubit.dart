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
      final result = await loginUser(username: username, password: password);

      // ✅ BACKEND KAMU PAKAI MESSAGE, BUKAN success
      if (result['message'] != null &&
          result['message'].toString().toLowerCase().contains('otp')) {
        emit(LoginOtpRequired(email: result['email'] ?? username));
        return;
      }

      // ❌ LOGIN GAGAL
      emit(
        LoginError(
          result['message']?.toString() ?? 'Email atau password tidak valid',
        ),
      );
    } catch (e) {
      emit(
        LoginError(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        ),
      );
    }
  }
}
