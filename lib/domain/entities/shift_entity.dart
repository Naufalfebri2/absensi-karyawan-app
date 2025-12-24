// =======================================================
// SHIFT ENTITY
// =======================================================

class ShiftEntity {
  final ShiftTime startTime;
  final ShiftTime endTime;
  final int toleranceMinutes;
  final bool isOvernight;

  const ShiftEntity({
    required this.startTime,
    required this.endTime,
    this.toleranceMinutes = 0,
    this.isOvernight = false,
  });

  factory ShiftEntity.defaultShift() {
    return const ShiftEntity(
      startTime: ShiftTime(hour: 8, minute: 0),
      endTime: ShiftTime(hour: 17, minute: 0),
      toleranceMinutes: 15,
      isOvernight: false,
    );
  }

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

  bool canCheckIn(DateTime now) {
    final start = getStartDateTime(now);
    final lateLimit = start.add(Duration(minutes: toleranceMinutes));
    return now.isAfter(start) && now.isBefore(lateLimit);
  }

  bool canCheckOut(DateTime now) {
    final end = getEndDateTime(now);
    return now.isAfter(end);
  }

  bool isLate(DateTime checkInTime) {
    final start = getStartDateTime(checkInTime);
    final lateLimit = start.add(Duration(minutes: toleranceMinutes));
    return checkInTime.isAfter(lateLimit);
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
