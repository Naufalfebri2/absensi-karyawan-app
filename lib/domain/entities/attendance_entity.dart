enum AttendanceStatus { onTime, late, leave, holiday, earlyLeave, overtime }

class AttendanceEntity {
  final DateTime date;

  /// STATUS UTAMA (BACKWARD COMPATIBLE)
  /// Dipakai UI lama (misalnya list singkat)
  final AttendanceStatus status;

  /// ===============================
  /// CHECK IN
  /// ===============================
  /// Format: HH:mm (24 jam)
  final String? checkInTime;
  final AttendanceStatus? checkInStatus;

  /// 🔥 BARU
  final String? checkInSelfiePath;

  /// ===============================
  /// CHECK OUT
  /// ===============================
  /// Format: HH:mm (24 jam)
  final String? checkOutTime;
  final AttendanceStatus? checkOutStatus;

  /// 🔥 BARU
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
  // COPY WITH 🔥
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
  // JSON → ENTITY
  // ===============================
  factory AttendanceEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceEntity(
      date: DateTime.parse(json['date']),
      status: _parseStatus(json['status']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      checkInStatus: json['check_in_status'] != null
          ? _parseStatus(json['check_in_status'])
          : null,
      checkOutStatus: json['check_out_status'] != null
          ? _parseStatus(json['check_out_status'])
          : null,
      checkInSelfiePath: json['check_in_selfie'],
      checkOutSelfiePath: json['check_out_selfie'],
    );
  }

  // ===============================
  // ENTITY → JSON (SIAP BACKEND)
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.name,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_status': checkInStatus?.name,
      'check_out_status': checkOutStatus?.name,
      'check_in_selfie': checkInSelfiePath,
      'check_out_selfie': checkOutSelfiePath,
    };
  }

  // ===============================
  // PARSE STATUS
  // ===============================
  static AttendanceStatus _parseStatus(String value) {
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
      case 'overtime':
        return AttendanceStatus.overtime;
      default:
        return AttendanceStatus.onTime;
    }
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
