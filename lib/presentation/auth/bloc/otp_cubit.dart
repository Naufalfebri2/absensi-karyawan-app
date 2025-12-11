import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/otp_verify.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpVerify verifyUsecase;

  OtpCubit(this.verifyUsecase) : super(OtpInitial());

  Future<void> submitOtp({
    required int userId,
    required String otp,
    required String tempToken,
  }) async {
    emit(OtpLoading());

    try {
      // Call OTP verify usecase
      final result = await verifyUsecase(
        userId: userId,
        otp: otp,
        tempToken: tempToken,
      );

      // SUCCESS RESPONSE
      if (result['success'] == true) {
        emit(OtpSuccess(token: result['token'], user: result['user']));
        return;
      }

      // FAILED RESPONSE
      emit(OtpError(result['message'] ?? "OTP tidak valid"));
    }
    // UNEXPECTED ERROR
    catch (e) {
      emit(OtpError("Terjadi kesalahan: $e"));
    }
  }
}
