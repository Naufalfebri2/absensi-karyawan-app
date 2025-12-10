import 'package:absensi_karyawan_app/domain/entities/attendance_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/attendance_repository.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  Future<AttendanceEntity> call({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) {
    return repository.checkIn(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );
  }
}
