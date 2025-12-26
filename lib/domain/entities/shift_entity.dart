// =======================================================
// SHIFT ENTITY
// =======================================================

class ShiftEntity {
  final ShiftTime startTime;
  final ShiftTime endTime;
  final int toleranceMinutes;
  final int overtimeToleranceMinutes;
  final bool isOvernight;

  const ShiftEntity({
    required this.startTime,
    required this.endTime,
    this.toleranceMinutes = 0,
    this.overtimeToleranceMinutes = 15,
    this.isOvernight = false,
  });

  factory ShiftEntity.defaultShift() {
    return const ShiftEntity(
      startTime: ShiftTime(hour: 8, minute: 0),
      endTime: ShiftTime(hour: 17, minute: 0),
      toleranceMinutes: 15,
      overtimeToleranceMinutes: 15,
      isOvernight: false,
    );
  }

  // ===============================
  // BASE DATETIME
  // ===============================
  DateTime getStartDateTime(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
  }

  DateTime getEndDateTime(DateTime date) {
    final endDate = isOvernight ? date.add(const Duration(days: 1)) : date;

    return DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );
  }

  // ===============================
  // CHECK IN LOGIC
  // ===============================

  /// Masih boleh Check In (termasuk sebelum jam masuk)
  bool canCheckIn(DateTime now) {
    final start = getStartDateTime(now);
    final lateLimit = start.add(Duration(minutes: toleranceMinutes));

    return now.isBefore(lateLimit);
  }

  /// Apakah Check In terlambat
  bool isLate(DateTime checkInTime) {
    final start = getStartDateTime(checkInTime);
    final lateLimit = start.add(Duration(minutes: toleranceMinutes));

    return checkInTime.isAfter(lateLimit);
  }

  // ===============================
  // CHECK OUT LOGIC
  // ===============================

  /// Sudah boleh Check Out
  bool canCheckOut(DateTime now) {
    final end = getEndDateTime(now);
    return now.isAfter(end);
  }

  /// Pulang lebih cepat
  bool isEarlyLeave(DateTime checkOutTime) {
    final end = getEndDateTime(checkOutTime);
    return checkOutTime.isBefore(end);
  }

  /// Lembur
  bool isOvertime(DateTime checkOutTime) {
    final end = getEndDateTime(checkOutTime);
    final overtimeLimit = end.add(Duration(minutes: overtimeToleranceMinutes));

    return checkOutTime.isAfter(overtimeLimit);
  }
}

// =======================================================
// SHIFT TIME (HH:mm)
// =======================================================
class ShiftTime {
  final int hour;
  final int minute;

  const ShiftTime({required this.hour, required this.minute});

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
