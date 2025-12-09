import '../../domain/entities/leave_entity.dart';
import '../models/leave_model.dart';

class LeaveMapper {
  static LeaveEntity toEntity(LeaveModel model) {
    return LeaveEntity(
      id: model.id,
      employeeId: model.employeeId,
      type: model.type,
      startDate: model.startDate,
      endDate: model.endDate,
      totalDays: model.totalDays,
      reason: model.reason,
      status: model.status,
      approvedBy: model.approvedBy,
      approvalDate: model.approvalDate,
    );
  }

  static LeaveModel toModel(LeaveEntity entity) {
    return LeaveModel(
      id: entity.id,
      employeeId: entity.employeeId,
      type: entity.type,
      startDate: entity.startDate,
      endDate: entity.endDate,
      totalDays: entity.totalDays,
      reason: entity.reason,
      status: entity.status,
      approvedBy: entity.approvedBy,
      approvalDate: entity.approvalDate,
    );
  }
}
