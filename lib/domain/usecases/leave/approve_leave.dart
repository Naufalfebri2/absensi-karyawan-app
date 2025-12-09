import 'package:absensi_karyawan_app/domain/entities/leave_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/leave_repo.dart';

class ApproveLeave {
  final LeaveRepository repository;

  ApproveLeave(this.repository);

  Future<LeaveEntity> call({
    required int leaveId,
    required bool isApproved,
    String? note,
  }) {
    return repository.approveLeave(
      leaveId: leaveId,
      isApproved: isApproved,
      note: note,
    );
  }
}
