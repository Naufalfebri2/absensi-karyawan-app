import '../../domain/entities/attendance_entity.dart';
import '../models/attendance_model.dart';

class AttendanceMapper {
  static AttendanceEntity toEntity(AttendanceModel model) {
    return AttendanceEntity(
      id: model.id,
      checkIn: model.checkIn,
      checkOut: model.checkOut,
      latitude: model.latitude,
      longitude: model.longitude,
      photoIn: model.photoIn,
      photoOut: model.photoOut,
      status: model.status,
    );
  }
}
