import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/remote/attendance_remote.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  // ===============================
  // ATTENDANCE HISTORY
  // ===============================
  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) {
    return remoteDataSource.getAttendanceHistory(year: year, month: month);
  }

  // ===============================
  // TODAY ATTENDANCE
  // ===============================
  @override
  Future<AttendanceEntity?> getTodayAttendance() {
    return remoteDataSource.getTodayAttendance();
  }

  // ===============================
  // CHECK IN
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

  // ===============================
  // CHECK OUT
  // ===============================
  @override
  Future<AttendanceEntity> checkOut() {
    return remoteDataSource.checkOut();
  }
}
