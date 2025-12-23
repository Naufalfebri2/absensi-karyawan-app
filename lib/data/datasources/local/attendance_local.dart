import '../../../domain/entities/attendance_entity.dart';

class AttendanceLocalDataSource {
  // ===================================================
  // GET ATTENDANCE HISTORY (DUMMY – API READY)
  // ===================================================
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) async {
    // Simulasi delay API
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      // 🔴 LIBUR NASIONAL
      AttendanceEntity(
        date: DateTime(year, month, 25),
        status: AttendanceStatus.holiday,
      ),

      // 🟠 TERLAMBAT
      AttendanceEntity(
        date: DateTime(year, month, 15),
        status: AttendanceStatus.late,
        checkInTime: "08:07",
        checkOutTime: "17:12",
      ),

      // 🟢 ON TIME
      AttendanceEntity(
        date: DateTime(year, month, 14),
        status: AttendanceStatus.onTime,
        checkInTime: "08:00",
        checkOutTime: "17:10",
      ),

      // 🔵 CUTI / IZIN
      AttendanceEntity(
        date: DateTime(year, month, 10),
        status: AttendanceStatus.leave,
      ),
    ];
  }

  // ===================================================
  // GET TODAY ATTENDANCE
  // ===================================================
  Future<AttendanceEntity?> getTodayAttendance(DateTime today) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Contoh: tanggal 25 libur nasional
    if (today.day == 25) {
      return AttendanceEntity(date: today, status: AttendanceStatus.holiday);
    }

    // Sudah check-in
    return AttendanceEntity(
      date: today,
      status: AttendanceStatus.onTime,
      checkInTime: "08:01",
      checkOutTime: null,
    );
  }

  // ===================================================
  // CHECK IN (SIMULASI)
  // ===================================================
  Future<AttendanceEntity> checkIn(DateTime now) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return AttendanceEntity(
      date: now,
      status: AttendanceStatus.onTime,
      checkInTime: "08:02",
      checkOutTime: null,
    );
  }

  // ===================================================
  // CHECK OUT (SIMULASI)
  // ===================================================
  Future<AttendanceEntity> checkOut(DateTime now) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return AttendanceEntity(
      date: now,
      status: AttendanceStatus.onTime,
      checkInTime: "08:02",
      checkOutTime: "17:05",
    );
  }
}
