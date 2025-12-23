import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_entity.dart';

/// =======================================================
/// FILTER ATTENDANCE (UI / UX)
/// =======================================================
enum AttendanceFilter { all, onTime, leave, holiday }

/// =======================================================
/// ATTENDANCE STATE
/// =======================================================
class AttendanceState extends Equatable {
  final bool loading;
  final bool actionLoading;
  final AttendanceFilter filter;
  final AttendanceEntity? todayAttendance;
  final List<AttendanceEntity> records;

  // ================= CALENDAR =================
  final int selectedYear;
  final int selectedMonth;
  final DateTime? selectedDate;
  final String? selectedHolidayName;

  AttendanceState({
    this.loading = false,
    this.actionLoading = false,
    this.filter = AttendanceFilter.all,
    this.todayAttendance,
    this.records = const [],
    required this.selectedYear,
    required this.selectedMonth,
    this.selectedDate,
    this.selectedHolidayName,
  });

  /// ===================================================
  /// INITIAL STATE (RUNTIME SAFE)
  /// ===================================================
  factory AttendanceState.initial() {
    final now = DateTime.now();

    return AttendanceState(
      loading: false,
      actionLoading: false,
      filter: AttendanceFilter.all,
      todayAttendance: null,
      records: const [],
      selectedYear: now.year,
      selectedMonth: now.month,
      selectedDate: null,
      selectedHolidayName: null,
    );
  }

  /// ===================================================
  /// COPY WITH
  /// ===================================================
  AttendanceState copyWith({
    bool? loading,
    bool? actionLoading,
    AttendanceFilter? filter,
    AttendanceEntity? todayAttendance,
    List<AttendanceEntity>? records,
    int? selectedYear,
    int? selectedMonth,
    DateTime? selectedDate,
    String? selectedHolidayName,
  }) {
    return AttendanceState(
      loading: loading ?? this.loading,
      actionLoading: actionLoading ?? this.actionLoading,
      filter: filter ?? this.filter,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      records: records ?? this.records,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedHolidayName: selectedHolidayName ?? this.selectedHolidayName,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    actionLoading,
    filter,
    todayAttendance,
    records,
    selectedYear,
    selectedMonth,
    selectedDate,
    selectedHolidayName,
  ];
}
