import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkin_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());

  Future<void> submitCheckIn({required bool isHoliday}) async {
    // ===============================
    // GUARD: HARI LIBUR NASIONAL
    // ===============================
    if (isHoliday) {
      emit(
        CheckInFailure('Hari libur nasional. Check In tidak dapat dilakukan.'),
      );
      return;
    }

    emit(CheckInLoading());

    try {
      // ===============================
      // TODO: ganti dengan API / usecase
      // ===============================
      await Future.delayed(const Duration(seconds: 2));

      emit(CheckInSuccess());
    } catch (_) {
      emit(CheckInFailure('Gagal melakukan Check In'));
    }
  }

  void reset() {
    emit(CheckInInitial());
  }
}
