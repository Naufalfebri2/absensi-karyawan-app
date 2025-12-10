import '../../entities/leave_entity.dart';
import '../../repositories/leave_repository.dart';

class SubmitLeave {
  final LeaveRepository repository;

  SubmitLeave(this.repository);

  Future<LeaveEntity> call(SubmitLeaveParams params) {
    return repository.submitLeave(
      employeeId: params.employeeId,
      leaveType: params.leaveType,
      description: params.description,
      startDate: params.startDate,
      endDate: params.endDate,
      attachmentPath: params.attachmentPath,
    );
  }
}

class SubmitLeaveParams {
  final int employeeId;
  final String leaveType; // contoh: "Sakit", "Cuti", "Izin"
  final String description; // alasan izin
  final DateTime startDate;
  final DateTime endDate;
  final String? attachmentPath;

  SubmitLeaveParams({
    required this.employeeId,
    required this.leaveType,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.attachmentPath,
  });
}
