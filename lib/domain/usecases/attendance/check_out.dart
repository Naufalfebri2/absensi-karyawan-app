import 'package:absensi_karyawan_app/domain/entities/attendance_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/attendance_repo.dart';

class CheckOut {
  final AttendanceRepository repository;

  CheckOut(this.repository);

  Future<AttendanceEntity> call({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) {
    return repository.checkOut(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
    );
  }
}
