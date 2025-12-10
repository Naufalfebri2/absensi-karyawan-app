import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final AttendanceRepository repo;

  CheckoutCubit(this.repo) : super(CheckoutInitial());

  Future<void> doCheckOut({
    // <-- FIX: pakai huruf besar O
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    emit(CheckoutLoading());

    try {
      final result = await repo.checkOut(
        employeeId: employeeId,
        latitude: latitude,
        longitude: longitude,
        photoPath: photoPath,
      );

      emit(CheckoutSuccess(result));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
