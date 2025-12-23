import 'package:equatable/equatable.dart';

/// =======================================================
/// ATTENDANCE STATUS (DITENTUKAN OLEH BACK-END)
/// =======================================================
enum AttendanceStatus { onTime, late, leave, holiday, absent }

/// =======================================================
/// ATTENDANCE ENTITY (DOMAIN LAYER)
/// =======================================================
class AttendanceEntity extends Equatable {
  final DateTime date;

  /// Status kehadiran (hasil business rule BE)
  final AttendanceStatus status;

  /// Jam check-in (HH:mm) – nullable
  final String? checkInTime;

  /// Jam check-out (HH:mm) – nullable
  final String? checkOutTime;

  const AttendanceEntity({
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
  });

  /// ===================================================
  /// HELPER (UNTUK UI & FILTER)
  /// ===================================================

  bool get isOnTime =>
      status == AttendanceStatus.onTime || status == AttendanceStatus.late;

  bool get isLeave => status == AttendanceStatus.leave;

  bool get isHoliday => status == AttendanceStatus.holiday;

  bool get hasCheckedIn => checkInTime != null;

  bool get hasCheckedOut => checkOutTime != null;

  /// ===================================================
  /// COPY WITH (OPTIONAL, UNTUK STATE UPDATE)
  /// ===================================================
  AttendanceEntity copyWith({
    DateTime? date,
    AttendanceStatus? status,
    String? checkInTime,
    String? checkOutTime,
  }) {
    return AttendanceEntity(
      date: date ?? this.date,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }

  @override
  List<Object?> get props => [date, status, checkInTime, checkOutTime];
}
