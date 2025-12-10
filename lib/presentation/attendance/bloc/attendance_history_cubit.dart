import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';

part 'attendance_history_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final AttendanceRepository repo;

  AttendanceHistoryCubit(this.repo) : super(AttendanceHistoryInitial());

  Future<void> loadHistory(int employeeId) async {
    emit(AttendanceHistoryLoading());
    try {
      final result = await repo.getAttendanceHistory(
        employeeId: employeeId, // ← FIXED (named parameter)
      );

      emit(AttendanceHistorySuccess(result));
    } catch (e) {
      emit(AttendanceHistoryError(e.toString()));
    }
  }
}
