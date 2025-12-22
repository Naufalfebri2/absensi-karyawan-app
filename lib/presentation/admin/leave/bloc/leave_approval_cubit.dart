import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:absensi_karyawan_app/domain/usecases/leave/get_pending_leaves.dart';
import 'package:absensi_karyawan_app/domain/usecases/leave/approve_leave.dart';
import 'package:absensi_karyawan_app/domain/usecases/leave/reject_leave.dart';

import 'leave_approval_state.dart';

class LeaveApprovalCubit extends Cubit<LeaveApprovalState> {
  final GetPendingLeaves getPendingLeaves;
  final ApproveLeaveUsecase approveLeave;
  final RejectLeaveUsecase rejectLeave;

  LeaveApprovalCubit({
    required this.getPendingLeaves,
    required this.approveLeave,
    required this.rejectLeave,
  }) : super(LeaveApprovalInitial());

  Future<void> load() async {
    emit(LeaveApprovalLoading());
    try {
      final data = await getPendingLeaves();
      emit(LeaveApprovalLoaded(data));
    } catch (_) {
      emit(LeaveApprovalError('Gagal memuat pengajuan cuti'));
    }
  }

  Future<void> approve(int id, {required String note}) async {
    emit(LeaveApprovalLoading());
    try {
      await approveLeave(id, note);
      await load();
    } catch (_) {
      emit(LeaveApprovalError('Gagal menyetujui cuti'));
    }
  }

  Future<void> reject(int id, {required String note}) async {
    emit(LeaveApprovalLoading());
    try {
      await rejectLeave(id, note);
      await load();
    } catch (_) {
      emit(LeaveApprovalError('Gagal menolak cuti'));
    }
  }
}
