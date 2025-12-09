import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  Future<LeaveEntity> submitLeave(LeaveEntity leave);

  Future<LeaveEntity> approveLeave({
    required int leaveId,
    required bool isApproved,
    String? note,
  });

  Future<List<LeaveEntity>> getLeaveHistory(int employeeId);
}
