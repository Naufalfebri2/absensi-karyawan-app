import '../entities/attendance_entity.dart';

/// =======================================================
/// ATTENDANCE REPOSITORY
/// Domain Contract (Clean Architecture)
/// =======================================================
///
/// Catatan penting:
/// - Repository ini TIDAK tahu data dari mana (API / Local)
/// - Semua business rule (On Time / Late / Holiday)
///   SUDAH dihitung oleh Back-End
/// - Front-End hanya consume & render
///
abstract class AttendanceRepository {
  /// ===============================
  /// GET ATTENDANCE HISTORY
  /// ===============================
  /// Mengambil riwayat attendance per bulan
  ///
  /// [year]  : tahun (contoh: 2025)
  /// [month] : bulan (1–12)
  ///
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  });

  /// ===============================
  /// GET TODAY ATTENDANCE
  /// ===============================
  /// Mengambil attendance hari ini (jika ada)
  ///
  /// Return null jika belum check-in
  ///
  Future<AttendanceEntity?> getTodayAttendance(DateTime today);

  /// ===============================
  /// CHECK IN
  /// ===============================
  /// Mengirim request check-in
  ///
  /// Validasi berikut dilakukan di Back-End:
  /// - Jam kerja
  /// - Toleransi keterlambatan
  /// - Libur nasional
  /// - Radius lokasi
  ///
  Future<AttendanceEntity> checkIn(DateTime now);

  /// ===============================
  /// CHECK OUT
  /// ===============================
  /// Mengirim request check-out
  ///
  Future<AttendanceEntity> checkOut(DateTime now);
}
