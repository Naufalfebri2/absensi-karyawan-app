import '../../entities/attendance_entity.dart';
import '../../repositories/attendance_repository.dart';

/// =======================================================
/// USE CASE: Get Today Attendance
/// -------------------------------------------------------
/// Tugas:
/// - Mengambil absensi HARI INI (1 record)
/// - Menjadi single source of truth untuk:
///   - Belum absen
///   - Sudah check-in
///   - Sudah check-out
///
/// ❌ Tidak mengatur UI
/// ❌ Tidak mengatur enable/disable tombol
/// =======================================================
class GetTodayAttendance {
  final AttendanceRepository repository;

  GetTodayAttendance(this.repository);

  /// Mengembalikan:
  /// - AttendanceEntity → jika sudah ada absensi hari ini
  /// - null → jika belum ada absensi hari ini
  Future<AttendanceEntity?> call() async {
    return await repository.getTodayAttendance();
  }
}
