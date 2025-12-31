import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/reset_password.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPassword resetPassword;

  ResetPasswordCubit(this.resetPassword) : super(ResetPasswordInitial());

  Future<void> submit({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());

    try {
      final res = await resetPassword(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (res['success'] == true) {
        emit(ResetPasswordSuccess());
      } else {
        emit(ResetPasswordError(res['message'] ?? 'Failed password reset'));
      }
    } catch (_) {
      emit(const ResetPasswordError('There was a mistake, try again'));
    }
  }
}
