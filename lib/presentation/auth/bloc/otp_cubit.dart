import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/otp_verify.dart';
import 'otp_state.dart';
import 'otp_purpose.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpVerify verifyUsecase;

  OtpCubit(this.verifyUsecase) : super(OtpInitial());

  Future<void> submitOtp({
    required String email,
    required String otp,
    required OtpPurpose purpose,
  }) async {
    emit(OtpLoading());

    try {
      final result = await verifyUsecase(email: email, otp: otp);

      // BACKEND PAKAI MESSAGE SEBAGAI INDIKATOR SUKSES
      final message = result['message']?.toString().toLowerCase() ?? '';

      if (message.contains('berhasil') || message.contains('success')) {
        // ================= LOGIN OTP =================
        if (purpose == OtpPurpose.login) {
          final token = result['token'];
          final user = result['user'];

          if (token == null || token.toString().isEmpty) {
            emit(
              OtpError(
                "OTP verification succeeded, but the token was not found",
              ),
            );
            return;
          }

          emit(OtpSuccess(token: token.toString(), user: user ?? {}));
          return;
        }

        // ================= FORGOT PASSWORD OTP =================
        emit(OtpSuccess(token: '', user: {}));
        return;
      }

      emit(OtpError(result['message']?.toString() ?? "Invalid OTP code"));
    } catch (_) {
      emit(
        OtpError(
          "Unable to verify OTP. Please check your internet connection.",
        ),
      );
    }
  }
}
