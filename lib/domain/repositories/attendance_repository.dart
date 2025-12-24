import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  });

  Future<AttendanceEntity?> getTodayAttendance();

  Future<AttendanceEntity> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  Future<AttendanceEntity> checkOut();
}
