import 'dart:io';

abstract class LeaveRepository {
  // ===============================
  // EMPLOYEE
  // ===============================

  Future<List<dynamic>> getLeaves();

  Future<void> createLeave({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment, // 🔥 TAMBAH INI
  });

  // ===============================
  // MANAGER / HR
  // ===============================

  Future<List<dynamic>> getPendingLeaves();
  Future<void> approveLeave(int leaveId, String note);
  Future<void> rejectLeave(int leaveId, String note);
}
