import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_state.dart';
import '../../../domain/entities/leave_entity.dart';
import '../../../domain/repositories/leave_repository.dart';
import '../../../data/datasources/local/holiday_local.dart';
import '../../../core/utils/holiday_utils.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final LeaveRepository leaveRepository;

  CalendarCubit(this.leaveRepository) : super(CalendarState.initial()) {
    _init();
  }

  // ===============================
  // INIT
  // ===============================
  void _init() {
    final now = DateTime.now();

    emit(
      state.copyWith(
        selectedDate: now,
        focusedMonth: DateTime(now.year, now.month),
        selectedYear: now.year,
        selectedMonth: now.month,
        availableYears: _generateYears(),
      ),
    );

    loadMonth(now);
  }

  // ===============================
  // GENERATE YEAR LIST
  // ===============================
  List<int> _generateYears() {
    final currentYear = DateTime.now().year;
    return List.generate(currentYear - 1990 + 1, (i) => 1990 + i);
  }

  // ===============================
  // CHANGE MONTH / YEAR
  // ===============================
  void changeMonth(int month) {
    final newDate = DateTime(state.selectedYear, month);
    emit(state.copyWith(selectedMonth: month, focusedMonth: newDate));
    loadMonth(newDate);
  }

  void changeYear(int year) {
    if (!state.availableYears.contains(year)) return;
    final newDate = DateTime(year, state.selectedMonth);
    emit(state.copyWith(selectedYear: year, focusedMonth: newDate));
    loadMonth(newDate);
  }

  void nextMonth() {
    final next = DateTime(state.selectedYear, state.selectedMonth + 1);
    _syncMonthYear(next);
  }

  void previousMonth() {
    final prev = DateTime(state.selectedYear, state.selectedMonth - 1);
    _syncMonthYear(prev);
  }

  void _syncMonthYear(DateTime date) {
    if (!state.availableYears.contains(date.year)) return;

    emit(
      state.copyWith(
        selectedYear: date.year,
        selectedMonth: date.month,
        focusedMonth: DateTime(date.year, date.month),
      ),
    );

    loadMonth(date);
  }

  // ===============================
  // SELECT DATE
  // ===============================
  void selectDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);

    emit(
      state.copyWith(
        selectedDate: date,
        selectedYear: date.year,
        selectedMonth: date.month,
        focusedMonth: DateTime(date.year, date.month),
        events: _buildEventsForDate(key),
      ),
    );
  }

  // ===============================
  // LOAD MONTH (API + HOLIDAY)
  // ===============================
  Future<void> loadMonth(DateTime month) async {
    emit(state.copyWith(loading: true));

    final isHoliday = HolidayUtils.isHoliday(month, HolidayLocal.holidays);

    final holidayName = HolidayUtils.getHolidayName(
      month,
      HolidayLocal.holidays,
    );

    final leaves = await leaveRepository.getApprovedLeavesByMonth(month: month);

    final Map<DateTime, List<LeaveEntity>> grouped = {};

    for (final leave in leaves) {
      DateTime date = leave.startDate!;
      while (!date.isAfter(leave.endDate!)) {
        final key = DateTime(date.year, date.month, date.day);
        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(leave);
        date = date.add(const Duration(days: 1));
      }
    }

    final selectedKey = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );

    emit(
      state.copyWith(
        leaveMap: grouped,
        events: _buildEventsForDate(selectedKey, map: grouped),
        isHoliday: isHoliday,
        holidayName: holidayName,
        loading: false,
      ),
    );
  }

  // ===============================
  // BUILD EVENTS FROM LEAVE MAP
  // ===============================
  List<CalendarEvent> _buildEventsForDate(
    DateTime date, {
    Map<DateTime, List<LeaveEntity>>? map,
  }) {
    final source = map ?? state.leaveMap;
    final leaves = source[date] ?? [];

    return leaves.map((leave) {
      return CalendarEvent(
        title: '${leave.employeeName} – ${leave.leaveType}',
        subtitle: leave.reason,
        avatarUrl: leave.employeeAvatar,
      );
    }).toList();
  }
}
