import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/forgot_password.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPassword forgotPassword;

  ForgotPasswordCubit(this.forgotPassword) : super(ForgotPasswordInitial());

  Future<void> submitEmail(String email) async {
    emit(ForgotPasswordLoading());

    try {
      final res = await forgotPassword(email: email);

      if (res['success'] == true) {
        emit(ForgotPasswordSuccess(email));
      } else {
        emit(ForgotPasswordError(res['message'] ?? 'Gagal mengirim kode OTP'));
      }
    } catch (_) {
      emit(ForgotPasswordError('Terjadi kesalahan, silakan coba lagi'));
    }
  }
}
