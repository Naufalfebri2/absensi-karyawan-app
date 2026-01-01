import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_action_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/remote/attendance_remote.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  // ===============================
  // READ ATTENDANCE HISTORY
  // ===============================
  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,

    // 🔥 NEW (API FILTER)
    String? status,

    // 🔒 OPTIONAL (future-proof)
    int? employeeId,
  }) {
    return remoteDataSource.getAttendanceHistory(
      year: year,
      month: month,
      status: status,
      employeeId: employeeId,
    );
  }

  // ===============================
  // READ TODAY ATTENDANCE
  // ===============================
  @override
  Future<AttendanceEntity?> getTodayAttendance({int? employeeId}) {
    return remoteDataSource.getTodayAttendance(employeeId: employeeId);
  }

  // ===============================
  // LEGACY API (BACKWARD COMPATIBLE)
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
    int? employeeId,
  }) {
    return remoteDataSource.saveCheckIn(
      time: time,
      status: status,
      selfiePath: selfiePath,
      latitude: latitude,
      longitude: longitude,
      employeeId: employeeId,
    );
  }

  @override
  Future<AttendanceActionEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
    int? employeeId,
  }) {
    return remoteDataSource.saveCheckOut(
      time: time,
      status: status,
      selfiePath: selfiePath,
      latitude: latitude,
      longitude: longitude,
      employeeId: employeeId,
    );
  }
}
