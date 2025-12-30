import 'package:absensi_karyawan_app/domain/entities/attendance_action_entity.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  // ===============================
  // READ
  // ===============================

  /// Riwayat absensi per bulan
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,

    // 🔥 OPTIONAL: untuk admin / manager
    int? employeeId,
  });

  /// Absensi hari ini
  Future<AttendanceEntity?> getTodayAttendance({
    // 🔥 OPTIONAL
    int? employeeId,
  });

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
  Future<AttendanceActionEntity> saveCheckIn({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,

    // 🔥 OPTIONAL
    int? employeeId,
  });

  /// Simpan Check-Out lengkap (selfie + status)
  Future<AttendanceEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,

    // 🔥 OPTIONAL
    int? employeeId,
  });
}
