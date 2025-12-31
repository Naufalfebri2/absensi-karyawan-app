import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/leave/get_leaves.dart';
import '../../../domain/usecases/leave/create_leave.dart';
import '../../../domain/entities/user_entity.dart';
import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final GetLeaves getLeaves;
  final CreateLeave createLeave;

  /// 🔥 User login (session)
  /// Bisa dari AuthCubit / SessionCubit / injected user
  final UserEntity user;

  LeaveCubit({
    required this.getLeaves,
    required this.createLeave,
    required this.user,
  }) : super(LeaveInitial());

  // ===============================
  // FETCH LEAVE HISTORY
  // ===============================
  Future<void> fetchLeaves() async {
    emit(LeaveLoading());
    try {
      final leaves = await getLeaves();
      emit(LeaveLoaded(leaves));
    } catch (_) {
      emit(LeaveError('Failed to load leave data'));
    }
  }

  // ===============================
  // SUBMIT LEAVE (FINAL + ATTACHMENT)
  // ===============================
  Future<void> submitLeave({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment,
  }) async {
    emit(LeaveLoading());

    try {
      await createLeave(
        employeeId: user.id, // ⬅️ INI INTI PERBAIKAN
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        totalDays: totalDays,
        attachment: attachment,
      );

      emit(LeaveSuccess());
    } catch (_) {
      emit(LeaveError('Failed to submit leave request'));
    }
  }
}
