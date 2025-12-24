enum AttendanceStatus { onTime, late, leave, holiday, earlyLeave, overtime }

class AttendanceEntity {
  final DateTime date;
  final AttendanceStatus status;

  /// Format: HH:mm (24 jam)
  final String? checkInTime;
  final String? checkOutTime;

  AttendanceEntity({
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
  });

  // ===============================
  // JSON → ENTITY
  // ===============================
  factory AttendanceEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceEntity(
      date: DateTime.parse(json['date']),
      status: _parseStatus(json['status']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
    );
  }

  // ===============================
  // PARSE STATUS
  // ===============================
  static AttendanceStatus _parseStatus(String value) {
    switch (value.toLowerCase()) {
      case 'on_time':
        return AttendanceStatus.onTime;
      case 'late':
        return AttendanceStatus.late;
      case 'leave':
        return AttendanceStatus.leave;
      case 'holiday':
        return AttendanceStatus.holiday;
      case 'early_leave':
        return AttendanceStatus.earlyLeave;
      case 'overtime':
        return AttendanceStatus.overtime;
      default:
        throw Exception('Unknown attendance status: $value');
    }
  }

  // ===============================
  // UI HELPERS (AMAN UNTUK KODE LAMA)
  // ===============================
  bool get isOnTime => status == AttendanceStatus.onTime;
  bool get isLate => status == AttendanceStatus.late;
  bool get isLeave => status == AttendanceStatus.leave;
  bool get isHoliday => status == AttendanceStatus.holiday;
  bool get isEarlyLeave => status == AttendanceStatus.earlyLeave;
  bool get isOvertime => status == AttendanceStatus.overtime;

  // ===============================
  // LOGIC HELPERS (UNTUK SHIFT)
  // ===============================

  /// Check apakah Check In tersedia
  bool get hasCheckIn => checkInTime != null && checkInTime!.isNotEmpty;

  /// Check apakah Check Out tersedia
  bool get hasCheckOut => checkOutTime != null && checkOutTime!.isNotEmpty;

  /// Parse HH:mm → DateTime (hari yang sama)
  DateTime? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;

    final parts = time.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime? get checkInDateTime => _parseTime(checkInTime);
  DateTime? get checkOutDateTime => _parseTime(checkOutTime);
}
