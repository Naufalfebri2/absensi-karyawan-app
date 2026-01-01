import 'dart:io';

import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/remote/leave_remote.dart';
import '../mappers/leave_mapper.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemote remote;

  LeaveRepositoryImpl(this.remote);

  // ===============================
  // EMPLOYEE
  // ===============================

  @override
  Future<List<LeaveEntity>> getLeaves() async {
    final rawData = await remote.fetchLeaves();

    return rawData.map<LeaveEntity>((e) => LeaveMapper.fromJson(e)).toList();
  }

  @override
  Future<void> createLeave({
    required int employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment,
  }) {
    return remote.createLeave(
      employeeId: employeeId,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      totalDays: totalDays,
      attachment: attachment,
    );
  }

  // ===============================
  // MANAGER / HR
  // ===============================

  @override
  Future<List<LeaveEntity>> getPendingLeaves() async {
    final rawData = await remote.fetchPendingLeaves();

    return rawData.map<LeaveEntity>((e) => LeaveMapper.fromJson(e)).toList();
  }

  @override
  Future<void> approveLeave(int leaveId, String note) {
    return remote.approveLeave(leaveId, note);
  }

  @override
  Future<void> rejectLeave(int leaveId, String note) {
    return remote.rejectLeave(leaveId, note);
  }

  // ===============================
  // CALENDAR (NEW)
  // ===============================

  /// GET approved leave untuk calendar (by month)
  @override
  Future<List<LeaveEntity>> getApprovedLeavesByMonth({
    required DateTime month,
  }) async {
    final formattedMonth =
        '${month.year.toString().padLeft(4, '0')}-'
        '${month.month.toString().padLeft(2, '0')}';

    final rawData = await remote.fetchApprovedLeavesByMonth(
      month: formattedMonth,
    );

    return rawData.map<LeaveEntity>((e) => LeaveMapper.fromJson(e)).toList();
  }
}
