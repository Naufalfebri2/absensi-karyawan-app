import 'dart:io';

import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  // ===============================
  // EMPLOYEE
  // ===============================

  Future<List<LeaveEntity>> getLeaves();

  Future<void> createLeave({
    required int employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment,
  });

  // ===============================
  // MANAGER / HR
  // ===============================

  Future<List<LeaveEntity>> getPendingLeaves();

  Future<void> approveLeave(int leaveId, String note);

  Future<void> rejectLeave(int leaveId, String note);

  // ===============================
  // CALENDAR (WAJIB)
  // ===============================

  Future<List<LeaveEntity>> getApprovedLeavesByMonth({required DateTime month});
}
