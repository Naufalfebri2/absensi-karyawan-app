import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/leave_entity.dart';
import '../../../domain/repositories/leave_repository.dart';

part 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final LeaveRepository leaveRepository;

  LeaveCubit(this.leaveRepository) : super(LeaveState.initial());

  /// ======================================================
  /// GET LEAVE HISTORY BY EMPLOYEE
  /// ======================================================
  Future<void> loadLeaves(int employeeId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await leaveRepository.getLeaveHistory(
        employeeId: employeeId,
      );

      emit(state.copyWith(isLoading: false, leaves: data, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// ======================================================
  /// SUBMIT NEW LEAVE
  /// ======================================================
  Future<void> submitLeave({
    required int employeeId,
    required String type,
    required String description,
    required DateTime start,
    required DateTime end,
    String? attachmentPath,
  }) async {
    emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));

    try {
      final result = await leaveRepository.submitLeave(
        employeeId: employeeId,
        leaveType: type,
        description: description,
        startDate: start,
        endDate: end,
        attachmentPath: attachmentPath,
      );

      emit(
        state.copyWith(isSubmitting: false, isSuccess: true, newLeave: result),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
