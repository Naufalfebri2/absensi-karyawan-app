import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  // ===============================
  // READ
  // ===============================
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  });

  Future<AttendanceEntity?> getTodayAttendance();

  // ===============================
  // LEGACY (BACKWARD COMPATIBLE)
  // ===============================
  /// Masih dipertahankan agar kode lama tidak rusak
  Future<AttendanceEntity> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  });

  Future<AttendanceEntity> checkOut();

  // ===============================
  // 🔥 NEW API (RECOMMENDED)
  // ===============================

  /// Simpan Check-In lengkap (selfie + status)
  Future<AttendanceEntity> saveCheckIn({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
  });

  /// Simpan Check-Out lengkap (selfie + status)
  Future<AttendanceEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
  });
}
