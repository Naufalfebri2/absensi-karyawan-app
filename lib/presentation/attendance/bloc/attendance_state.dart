import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_entity.dart';

enum AttendanceFilter { all, onTime, leave, holiday }

class AttendanceState extends Equatable {
  final bool loading;
  final bool actionLoading;
  final AttendanceFilter filter;

  final AttendanceEntity? todayAttendance;
  final List<AttendanceEntity> records;

  final int selectedYear;
  final int selectedMonth;
  final DateTime? selectedDate;
  final String? selectedHolidayName;

  final Map<DateTime, String> holidays;

  const AttendanceState({
    this.loading = false,
    this.actionLoading = false,
    this.filter = AttendanceFilter.all,
    this.todayAttendance,
    this.records = const [],
    required this.selectedYear,
    required this.selectedMonth,
    this.selectedDate,
    this.selectedHolidayName,
    Map<DateTime, String>? holidays,
  }) : holidays = holidays ?? const {};

  factory AttendanceState.initial() {
    final now = DateTime.now();
    return AttendanceState(
      selectedYear: now.year,
      selectedMonth: now.month,
      holidays: const {},
    );
  }

  AttendanceState copyWith({
    bool? loading,
    bool? actionLoading,
    AttendanceFilter? filter,

    AttendanceEntity? todayAttendance,
    bool clearTodayAttendance = false,

    List<AttendanceEntity>? records,

    int? selectedYear,
    int? selectedMonth,

    DateTime? selectedDate,
    bool clearSelectedDate = false,

    String? selectedHolidayName,
    bool clearSelectedHoliday = false,

    Map<DateTime, String>? holidays,
    bool clearHolidays = false,
  }) {
    return AttendanceState(
      loading: loading ?? this.loading,
      actionLoading: actionLoading ?? this.actionLoading,
      filter: filter ?? this.filter,

      todayAttendance: clearTodayAttendance
          ? null
          : (todayAttendance ?? this.todayAttendance),

      records: records ?? this.records,

      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,

      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),

      selectedHolidayName: clearSelectedHoliday
          ? null
          : (selectedHolidayName ?? this.selectedHolidayName),

      holidays: clearHolidays ? const {} : (holidays ?? this.holidays),
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
    holidays,
  ];
}
