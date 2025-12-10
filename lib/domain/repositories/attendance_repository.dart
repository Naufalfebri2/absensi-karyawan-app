import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  /// CHECK IN
  Future<AttendanceEntity> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  /// CHECK OUT
  Future<AttendanceEntity> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  /// GET HISTORY RANGE
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// GET TODAY ATTENDANCE (untuk HomePage)
  Future<AttendanceEntity?> getTodayAttendance({required int employeeId});
}
