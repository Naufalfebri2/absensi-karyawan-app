import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/remote/leave_remote.dart';
import '../mappers/leave_mapper.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemote remote;

  LeaveRepositoryImpl(this.remote);

  /// SUBMIT LEAVE
  @override
  Future<LeaveEntity> submitLeave({
    required int employeeId,
    required String leaveType,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String? attachmentPath,
  }) async {
    final model = await remote.submitLeave(
      employeeId: employeeId,
      leaveType: leaveType,
      description: description,
      startDate: startDate,
      endDate: endDate,
      attachmentPath: attachmentPath,
    );

    return LeaveMapper.toEntity(model);
  }

  /// GET HISTORY
  @override
  Future<List<LeaveEntity>> getLeaveHistory({required int employeeId}) async {
    final models = await remote.getLeaveHistory(employeeId: employeeId);
    return models.map((m) => LeaveMapper.toEntity(m)).toList();
  }

  /// APPROVAL (ADMIN / MANAGER)
  @override
  Future<LeaveEntity> approveLeave({
    required int leaveId,
    required bool isApproved,
    String? note,
  }) async {
    final model = await remote.approveLeave(
      leaveId: leaveId,
      isApproved: isApproved,
      note: note,
    );

    return LeaveMapper.toEntity(model);
  }
}
