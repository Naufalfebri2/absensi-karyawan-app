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
        emit(
          LoginSuccess(
            userId: result['user_id'],
            tempToken: result['temp_token'],
          ),
        );
      } else {
        emit(LoginError(result['message'] ?? "Login gagal"));
      }
    } catch (e) {
      emit(LoginError("Terjadi kesalahan: $e"));
    }
  }
}
