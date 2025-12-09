import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repo.dart';
import '../datasources/remote/attendance_remote.dart';
import '../mappers/attendance_mapper.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remote;

  AttendanceRepositoryImpl(this.remote);

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

  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await remote.getHistory(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );
    return data.map((e) => AttendanceMapper.toEntity(e)).toList();
  }

  @override
  Future<AttendanceEntity?> getAttendanceDetail(int logId) async {
    final model = await remote.getDetail(logId);
    return model != null ? AttendanceMapper.toEntity(model) : null;
  }
}
