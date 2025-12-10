import '../../entities/attendance_entity.dart';
import '../../repositories/attendance_repository.dart';

class GetTodayAttendance {
  final AttendanceRepository repository;

  GetTodayAttendance(this.repository);

  /// Mengembalikan null jika user belum check in.
  Future<AttendanceEntity?> call(int employeeId) async {
    return await repository.getTodayAttendance(employeeId);
  }
}
