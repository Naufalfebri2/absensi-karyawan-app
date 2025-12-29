enum AttendanceStatus { onTime, late, leave, holiday, earlyLeave, overtime }

class AttendanceEntity {
  final DateTime date;

  /// STATUS UTAMA (BACKWARD COMPATIBLE)
  final AttendanceStatus status;

  /// ===============================
  /// CHECK IN
  /// ===============================
  /// Format: HH:mm
  final String? checkInTime;
  final AttendanceStatus? checkInStatus;
  final String? checkInSelfiePath;

  /// ===============================
  /// CHECK OUT
  /// ===============================
  /// Format: HH:mm
  final String? checkOutTime;
  final AttendanceStatus? checkOutStatus;
  final String? checkOutSelfiePath;

  AttendanceEntity({
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkInStatus,
    this.checkInSelfiePath,
    this.checkOutTime,
    this.checkOutStatus,
    this.checkOutSelfiePath,
  });

  // ===============================
  // COPY WITH
  // ===============================
  AttendanceEntity copyWith({
    DateTime? date,
    AttendanceStatus? status,
    String? checkInTime,
    AttendanceStatus? checkInStatus,
    String? checkInSelfiePath,
    String? checkOutTime,
    AttendanceStatus? checkOutStatus,
    String? checkOutSelfiePath,
  }) {
    return AttendanceEntity(
      date: date ?? this.date,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkInStatus: checkInStatus ?? this.checkInStatus,
      checkInSelfiePath: checkInSelfiePath ?? this.checkInSelfiePath,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkOutStatus: checkOutStatus ?? this.checkOutStatus,
      checkOutSelfiePath: checkOutSelfiePath ?? this.checkOutSelfiePath,
    );
  }

  // ===============================
  // API → ENTITY (FIXED)
  // ===============================
  factory AttendanceEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceEntity(
      date: DateTime.now(), // API belum kirim tanggal
      status: _parseStatus(json['status']),
      checkInTime: _formatTime(json['time_checkin']),
      checkOutTime: _formatTime(json['time_checkout']),
      checkInSelfiePath: json['photo_in'],
      checkOutSelfiePath: json['photo_out'],
    );
  }

  // ===============================
  // ENTITY → JSON
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.name,
      'time_checkin': checkInTime,
      'time_checkout': checkOutTime,
      'photo_in': checkInSelfiePath,
      'photo_out': checkOutSelfiePath,
    };
  }

  // ===============================
  // PARSE STATUS (FIXED)
  // ===============================
  static AttendanceStatus _parseStatus(String? value) {
    if (value == null) return AttendanceStatus.onTime;

    switch (value.toLowerCase()) {
      case 'on_time':
      case 'ontime':
        return AttendanceStatus.onTime;
      case 'late':
        return AttendanceStatus.late;
      case 'leave':
        return AttendanceStatus.leave;
      case 'holiday':
        return AttendanceStatus.holiday;
      case 'early_leave':
        return AttendanceStatus.earlyLeave;
      case 'lembur':
      case 'overtime':
        return AttendanceStatus.overtime;
      default:
        return AttendanceStatus.onTime;
    }
  }

  // ===============================
  // FORMAT JAM HH:mm:ss → HH:mm
  // ===============================
  static String? _formatTime(String? time) {
    if (time == null || time.isEmpty) return null;
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  // ===============================
  // UI HELPERS
  // ===============================
  bool get isOnTime => status == AttendanceStatus.onTime;
  bool get isLate => status == AttendanceStatus.late;
  bool get isLeave => status == AttendanceStatus.leave;
  bool get isHoliday => status == AttendanceStatus.holiday;
  bool get isEarlyLeave => status == AttendanceStatus.earlyLeave;
  bool get isOvertime => status == AttendanceStatus.overtime;

  // ===============================
  // LOGIC HELPERS
  // ===============================
  bool get hasCheckIn => checkInTime != null && checkInTime!.isNotEmpty;
  bool get hasCheckOut => checkOutTime != null && checkOutTime!.isNotEmpty;
  bool get hasCheckInSelfie =>
      checkInSelfiePath != null && checkInSelfiePath!.isNotEmpty;
  bool get hasCheckOutSelfie =>
      checkOutSelfiePath != null && checkOutSelfiePath!.isNotEmpty;

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
