import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/remote/attendance_remote.dart';
import '../../domain/entities/attendance_action_entity.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  // ===============================
  // READ
  // ===============================
  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) {
    return remoteDataSource.getAttendanceHistory(year: year, month: month);
  }

  @override
  Future<AttendanceEntity?> getTodayAttendance() {
    return remoteDataSource.getTodayAttendance();
  }

  // ===============================
  // LEGACY (BACKWARD COMPATIBLE)
  // ===============================
  @override
  Future<AttendanceEntity> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) {
    return remoteDataSource.checkIn(
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );
  }

  @override
  Future<AttendanceEntity> checkOut() {
    return remoteDataSource.checkOut();
  }

  // ===============================
  // 🔥 NEW API (RECOMMENDED)
  // ===============================

  @override
  Future<AttendanceActionEntity> saveCheckIn({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
  }) {
    return remoteDataSource.saveCheckIn(
      time: time,
      status: status,
      selfiePath: selfiePath,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<AttendanceEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
  }) {
    return remoteDataSource.saveCheckOut(
      time: time,
      status: status,
      selfiePath: selfiePath,
    );
  }
}
