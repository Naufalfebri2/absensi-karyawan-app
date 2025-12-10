import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  /// SUBMIT LEAVE
  Future<LeaveEntity> submitLeave({
    required int employeeId,
    required String leaveType,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String? attachmentPath,
  });

  /// ADMIN / MANAGER APPROVAL
  Future<LeaveEntity> approveLeave({
    required int leaveId,
    required bool isApproved,
    String? note,
  });

  /// GET HISTORY BY EMPLOYEE
  Future<List<LeaveEntity>> getLeaveHistory({required int employeeId});
}
