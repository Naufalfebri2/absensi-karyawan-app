import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repo.dart';
import '../datasources/remote/leave_remote.dart';
import '../mappers/leave_mapper.dart';
import '../models/leave_model.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemote remote;

  LeaveRepositoryImpl(this.remote);

  @override
  Future<LeaveEntity> submitLeave(LeaveEntity leave) async {
    final model = LeaveMapper.toModel(leave);

    // remote must return LeaveModel
    final LeaveModel result = await remote.submitLeave(model.toJson());

    return LeaveMapper.toEntity(result);
  }

  @override
  Future<LeaveEntity> approveLeave({
    required int leaveId,
    required bool isApproved,
    String? note,
  }) async {
    final LeaveModel result = await remote.approveLeave(
      leaveId: leaveId,
      isApproved: isApproved,
      note: note,
    );

    return LeaveMapper.toEntity(result);
  }

  @override
  Future<List<LeaveEntity>> getLeaveHistory(int employeeId) async {
    final List<LeaveModel> data = await remote.getLeaveHistory(employeeId);
    return data.map((e) => LeaveMapper.toEntity(e)).toList();
  }
}
