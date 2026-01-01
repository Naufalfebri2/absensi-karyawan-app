import 'package:equatable/equatable.dart';
import '../../../domain/entities/leave_entity.dart';

class CalendarEvent {
  final String title;
  final String subtitle;
  final String avatarUrl;

  const CalendarEvent({
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
  });
}

class CalendarState extends Equatable {
  // ===============================
  // CORE DATE STATE
  // ===============================
  final DateTime focusedMonth;
  final DateTime selectedDate;

  // ===============================
  // MONTH & YEAR CONTROL
  // ===============================
  final int selectedYear;
  final int selectedMonth;
  final List<int> availableYears;

  // ===============================
  // EVENTS & UI STATE
  // ===============================
  final List<CalendarEvent> events;
  final bool loading;

  // ===============================
  // HOLIDAY
  // ===============================
  final bool isHoliday;
  final String? holidayName;

  // ===============================
  // ✅ LEAVE DATA (WAJIB UNTUK CALENDAR)
  // ===============================
  final Map<DateTime, List<LeaveEntity>> leaveMap;

  const CalendarState({
    required this.focusedMonth,
    required this.selectedDate,
    required this.selectedYear,
    required this.selectedMonth,
    required this.availableYears,
    this.events = const [],
    this.loading = false,
    this.isHoliday = false,
    this.holidayName,
    this.leaveMap = const {}, // ✅ default aman
  });

  // ===============================
  // INITIAL STATE
  // ===============================
  factory CalendarState.initial() {
    final now = DateTime.now();
    final years = List.generate(now.year - 1990 + 1, (i) => 1990 + i);

    return CalendarState(
      focusedMonth: DateTime(now.year, now.month),
      selectedDate: now,
      selectedYear: now.year,
      selectedMonth: now.month,
      availableYears: years,
      events: const [],
      loading: false,
      isHoliday: false,
      holidayName: null,
      leaveMap: const {}, // ✅ init
    );
  }

  // ===============================
  // COPY WITH
  // ===============================
  CalendarState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    int? selectedYear,
    int? selectedMonth,
    List<int>? availableYears,
    List<CalendarEvent>? events,
    bool? loading,
    bool? isHoliday,
    String? holidayName,
    Map<DateTime, List<LeaveEntity>>? leaveMap,
  }) {
    return CalendarState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      availableYears: availableYears ?? this.availableYears,
      events: events ?? this.events,
      loading: loading ?? this.loading,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName ?? this.holidayName,
      leaveMap: leaveMap ?? this.leaveMap,
    );
  }

  @override
  List<Object?> get props => [
    focusedMonth,
    selectedDate,
    selectedYear,
    selectedMonth,
    availableYears,
    events,
    loading,
    isHoliday,
    holidayName,
    leaveMap, // ✅ WAJIB
  ];
}
