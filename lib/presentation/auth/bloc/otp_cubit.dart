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
    required String tempToken, // 🔥 WAJIB
    required OtpPurpose purpose,
  }) async {
    emit(OtpLoading());

    try {
      final result = await verifyUsecase(
        email: email,
        otp: otp,
        tempToken: tempToken, // 🔥 KIRIM KE BACKEND
      );

      if (result['success'] == true) {
        // ================= LOGIN OTP =================
        if (purpose == OtpPurpose.login) {
          final token = result['token'];
          final user = result['user'];

          if (token == null || token.toString().isEmpty) {
            emit(OtpError("Verifikasi berhasil tetapi token tidak ditemukan"));
            return;
          }

          emit(OtpSuccess(token: token.toString(), user: user ?? {}));
          return;
        }

        // ================= FORGOT PASSWORD OTP =================
        emit(OtpSuccess(token: '', user: {}));
        return;
      }

      emit(OtpError(result['message']?.toString() ?? "Kode OTP tidak valid"));
    } catch (_) {
      emit(
        OtpError(
          "Tidak dapat memverifikasi OTP. Periksa koneksi internet Anda.",
        ),
      );
    }
  }
}
