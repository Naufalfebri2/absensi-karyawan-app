import '../../domain/repositories/leave_repository.dart';
import '../../domain/entities/leave_entity.dart';
import '../datasources/remote/leave_remote.dart';
import '../mappers/leave_mapper.dart';
import 'dart:io';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemote remote;

  LeaveRepositoryImpl(this.remote);

  // ===============================
  // EMPLOYEE
  // ===============================

  @override
  Future<List<LeaveEntity>> getLeaves() async {
    final rawData = await remote.fetchLeaves();

    // 🔥 Mapping API → Domain Entity (WAJIB)
    return rawData.map<LeaveEntity>((e) => LeaveMapper.fromJson(e)).toList();
  }

  @override
  Future<void> createLeave({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment,
  }) {
    return remote.createLeave(
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
}
