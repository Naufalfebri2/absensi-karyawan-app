import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';

part 'checkin_state.dart';

class CheckinCubit extends Cubit<CheckinState> {
  final AttendanceRepository repo;

  CheckinCubit(this.repo) : super(CheckinInitial());

  /// Method utama untuk check-in
  Future<void> doCheckIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    emit(CheckinLoading());

    try {
      final result = await repo.checkIn(
        employeeId: employeeId,
        latitude: latitude,
        longitude: longitude,
        photoPath: photoPath,
      );

      emit(CheckinSuccess(result));
    } catch (e) {
      emit(CheckinError(e.toString()));
    }
  }

  /// ALIAS supaya UI bisa tetap memanggil `checkIn()`
  Future<void> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) {
    return doCheckIn(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );
  }
}
