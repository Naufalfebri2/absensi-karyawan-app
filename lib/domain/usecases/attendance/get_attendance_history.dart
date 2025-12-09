import 'package:absensi_karyawan_app/domain/entities/attendance_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/attendance_repo.dart';

class GetAttendanceHistory {
  final AttendanceRepository repository;

  GetAttendanceHistory(this.repository);

  Future<List<AttendanceEntity>> call({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getAttendanceHistory(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
