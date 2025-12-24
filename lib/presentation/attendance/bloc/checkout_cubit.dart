import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());

  Future<void> submitCheckOut({required bool isHoliday}) async {
    // ===============================
    // GUARD: HARI LIBUR NASIONAL
    // ===============================
    if (isHoliday) {
      emit(
        CheckOutFailure(
          'Hari libur nasional. Check Out tidak dapat dilakukan.',
        ),
      );
      return;
    }

    emit(CheckOutLoading());

    try {
      // ===============================
      // TODO: ganti dengan API / usecase
      // ===============================
      await Future.delayed(const Duration(seconds: 2));

      emit(CheckOutSuccess());
    } catch (_) {
      emit(CheckOutFailure('Gagal melakukan Check Out'));
    }
  }

  void reset() {
    emit(CheckOutInitial());
  }
}
