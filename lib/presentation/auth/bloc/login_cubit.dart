import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import '../../../domain/usecases/auth/login_user.dart';

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

      if (result['success'] == true) {
        final int userId = result['user_id'] ?? 0;
        final String tempToken = result['temp_token'] ?? '';

        if (tempToken.isEmpty) {
          emit(LoginError("Gagal memproses login. Silakan coba kembali."));
          return;
        }

        emit(LoginSuccess(userId: userId, tempToken: tempToken));
      } else {
        emit(
          LoginError(
            result['message']?.toString() ??
                "Username atau password tidak valid.",
          ),
        );
      }
    } catch (_) {
      emit(
        LoginError(
          "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
        ),
      );
    }
  }
}
