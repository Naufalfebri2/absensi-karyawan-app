import 'package:equatable/equatable.dart';

class CalendarEvent {
  final String title;
  final String subtitle;
  final String avatarUrl;

  CalendarEvent({
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
  });
}

class CalendarState extends Equatable {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final bool loading;

  // 🔥 HR FEATURE (DITAMBAHKAN)
  final bool isHoliday;
  final String? holidayName;

  const CalendarState({
    required this.focusedMonth,
    required this.selectedDate,
    this.events = const [],
    this.loading = false,
    this.isHoliday = false,
    this.holidayName,
  });

  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(
      focusedMonth: DateTime(now.year, now.month),
      selectedDate: now,
      events: const [],
      loading: false,
      isHoliday: false,
      holidayName: null,
    );
  }

  CalendarState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<CalendarEvent>? events,
    bool? loading,
    bool? isHoliday,
    String? holidayName,
  }) {
    return CalendarState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      events: events ?? this.events,
      loading: loading ?? this.loading,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName,
    );
  }

  @override
  List<Object?> get props => [
    focusedMonth,
    selectedDate,
    events,
    loading,
    isHoliday,
    holidayName,
  ];
}
