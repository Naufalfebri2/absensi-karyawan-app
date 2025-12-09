import '../../domain/entities/attendance_entity.dart';

abstract class AttendanceRepository {
  // CHECK IN
  Future<AttendanceEntity> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  // CHECK OUT
  Future<AttendanceEntity> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  // GET ATTENDANCE HISTORY
  Future<List<AttendanceEntity>> getAttendanceHistory(int employeeId);

  // GET DETAIL (OPTIONAL)
  Future<AttendanceEntity?> getAttendanceDetail(int logId);
}
