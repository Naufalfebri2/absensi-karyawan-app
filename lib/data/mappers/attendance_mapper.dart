import '../../domain/entities/attendance_entity.dart';
import '../models/attendance_model.dart';

class AttendanceMapper {
  static AttendanceEntity toEntity(AttendanceModel model) {
    return AttendanceEntity(
      id: model.id,
      employeeId: model.employeeId,
      checkIn: model.checkIn,
      checkOut: model.checkOut,
      latitude: model.latitude,
      longitude: model.longitude,
      photoIn: model.photoIn,
      photoOut: model.photoOut,
      status: model.status,
      totalWorkHours: model.totalWorkHours,
    );
  }

  static AttendanceModel toModel(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      employeeId: entity.employeeId,
      checkIn: entity.checkIn,
      checkOut: entity.checkOut,
      latitude: entity.latitude,
      longitude: entity.longitude,
      photoIn: entity.photoIn,
      photoOut: entity.photoOut,
      status: entity.status,
      totalWorkHours: entity.totalWorkHours,
    );
  }
}
