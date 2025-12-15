import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/otp_verify.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpVerify verifyUsecase;

  OtpCubit(this.verifyUsecase) : super(OtpInitial());

  Future<void> submitOtp({required String email, required String otp}) async {
    emit(OtpLoading());

    try {
      final result = await verifyUsecase(email: email, otp: otp);

      if (result['success'] == true) {
        final String token = result['token'] ?? '';
        final dynamic user = result['user'];

        if (token.isEmpty) {
          emit(
            OtpError("Verifikasi berhasil tetapi data login tidak lengkap."),
          );
          return;
        }

        emit(OtpSuccess(token: token, user: user));
        return;
      }

      emit(OtpError(result['message']?.toString() ?? "Kode OTP tidak valid."));
    } catch (_) {
      emit(
        OtpError(
          "Tidak dapat memverifikasi OTP. Periksa koneksi internet Anda.",
        ),
      );
    }
  }
}
