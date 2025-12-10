import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../core/services/device/local_storage_service.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository authRepo;

  OtpCubit(this.authRepo) : super(const OtpState());

  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await authRepo.verifyOtp(otp);

      await LocalStorageService.saveToken(user.token);

      emit(state.copyWith(isLoading: false, isVerified: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
