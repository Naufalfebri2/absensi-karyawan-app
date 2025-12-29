import 'dart:io';

abstract class LeaveRepository {
  // ===============================
  // EMPLOYEE
  // ===============================

  Future<List<dynamic>> getLeaves();

  Future<void> createLeave({
    required int employeeId, // ⬅️ WAJIB DITAMBAHKAN
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

  Future<List<dynamic>> getPendingLeaves();

  Future<void> approveLeave(int leaveId, String note);

  Future<void> rejectLeave(int leaveId, String note);
}
