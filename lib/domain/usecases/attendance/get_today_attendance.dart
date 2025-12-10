import '../../entities/attendance_entity.dart';
import '../../repositories/attendance_repository.dart';

class GetTodayAttendance {
  final AttendanceRepository repository;

  const GetTodayAttendance(this.repository);

  /// Mengembalikan data absensi hari ini.
  /// Return `null` jika belum check-in.
  Future<AttendanceEntity?> call(int employeeId) async {
    try {
      return await repository.getTodayAttendance(employeeId);
    } catch (e, stack) {
      // Bisa disesuaikan, biar error tidak bikin aplikasi crash.
      print('Error in GetTodayAttendance: $e');
      print(stack);
      return null;
    }
  }
}
