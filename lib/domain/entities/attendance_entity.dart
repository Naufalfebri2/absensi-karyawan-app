enum AttendanceStatus { onTime, late, leave, holiday }

class AttendanceEntity {
  final DateTime date;
  final AttendanceStatus status;
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
  // HELPER
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
      default:
        throw Exception('Unknown attendance status: $value');
    }
  }

  // ===============================
  // UI HELPERS
  // ===============================
  bool get isOnTime => status == AttendanceStatus.onTime;
  bool get isLeave => status == AttendanceStatus.leave;
  bool get isHoliday => status == AttendanceStatus.holiday;
}
