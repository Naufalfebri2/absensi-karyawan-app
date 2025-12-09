import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  Future<AttendanceEntity> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
