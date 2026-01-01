import '../bloc/attendance_state.dart';

/// =======================================================
/// ATTENDANCE STATUS MAPPER
/// =======================================================
/// Mapping dari AttendanceFilter (UI)
/// ke string status API (backend – Bahasa Indonesia)
///
/// Backend status (berdasarkan Postman):
/// - "Tepat Waktu"
/// - "Terlambat"
/// - "Pulang Cepat"
/// - "Lembur"
/// - "Tidak Hadir"
/// - "Izin"
/// - "Libur"
///
/// Jika return null → API akan ambil semua data
/// =======================================================
String? mapAttendanceFilterToApiStatus(AttendanceFilter filter) {
  switch (filter) {
    case AttendanceFilter.onTime:
      // Backend sudah menentukan Tepat Waktu / Terlambat
      return 'Tepat Waktu';

    case AttendanceFilter.leave:
      return 'Izin';

    case AttendanceFilter.holiday:
      return 'Libur';

    case AttendanceFilter.all:
      // Tidak kirim parameter status
      return null;
  }
}
