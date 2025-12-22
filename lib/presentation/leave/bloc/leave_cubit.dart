import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/leave/get_leaves.dart';
import '../../../domain/usecases/leave/create_leave.dart';
import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final GetLeaves getLeaves;
  final CreateLeave createLeave;

  LeaveCubit({required this.getLeaves, required this.createLeave})
    : super(LeaveInitial());

  // ===============================
  // FETCH LEAVE HISTORY
  // (sementara aman, tapi backend belum ada GET)
  // ===============================
  Future<void> fetchLeaves() async {
    emit(LeaveLoading());
    try {
      final leaves = await getLeaves();
      emit(LeaveLoaded(leaves));
    } catch (_) {
      emit(LeaveError('Gagal memuat data cuti'));
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
    File? attachment, // 🔥 TAMBAH INI
  }) async {
    emit(LeaveLoading());

    try {
      await createLeave(
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        totalDays: totalDays,
        attachment: attachment, // 🔥 TERUSKAN
      );

      // cukup success saja, jangan fetch history
      emit(LeaveSuccess());
    } catch (_) {
      emit(LeaveError('Gagal mengajukan cuti'));
    }
  }
}
