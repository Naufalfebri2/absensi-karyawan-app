import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/remote/attendance_remote.dart';
import '../mappers/attendance_mapper.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remote;

  AttendanceRepositoryImpl(this.remote);

  // ======================================================
  // CHECK IN
  // ======================================================
  @override
  Future<AttendanceEntity> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final model = await remote.checkIn(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );

    return AttendanceMapper.toEntity(model);
  }

  // ======================================================
  // CHECK OUT
  // ======================================================
  @override
  Future<AttendanceEntity> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final model = await remote.checkOut(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );

    return AttendanceMapper.toEntity(model);
  }

  // ======================================================
  // TODAY ATTENDANCE (NEW)
  // ======================================================
  @override
  Future<AttendanceEntity?> getTodayAttendance({
    required int employeeId,
  }) async {
    final model = await remote.getTodayAttendance(employeeId: employeeId);

    if (model == null) return null;

    return AttendanceMapper.toEntity(model);
  }

  // ======================================================
  // HISTORY
  // ======================================================
  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final list = await remote.getHistory(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );

    return list.map((e) => AttendanceMapper.toEntity(e)).toList();
  }

  // ======================================================
  // DETAIL (OPTIONAL)
  // ======================================================
  @override
  Future<AttendanceEntity?> getAttendanceDetail(int logId) async {
    final model = await remote.getDetail(logId);
    return model != null ? AttendanceMapper.toEntity(model) : null;
  }
}
