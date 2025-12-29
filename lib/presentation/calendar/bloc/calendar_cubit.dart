import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_state.dart';
import '../../../data/datasources/local/holiday_local.dart';
import '../../../core/utils/holiday_utils.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial()) {
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

    loadDate(now);
  }

  // ===============================
  // GENERATE YEAR LIST (1990 - CURRENT)
  // ===============================
  List<int> _generateYears() {
    final currentYear = DateTime.now().year;
    return List.generate(currentYear - 1990 + 1, (i) => 1990 + i);
  }

  // ===============================
  // CHANGE MONTH (DROPDOWN / ARROW)
  // ===============================
  void changeMonth(int month) {
    final newDate = DateTime(state.selectedYear, month);

    emit(state.copyWith(selectedMonth: month, focusedMonth: newDate));

    loadDate(newDate);
  }

  // ===============================
  // CHANGE YEAR (DROPDOWN / ARROW)
  // ===============================
  void changeYear(int year) {
    if (!state.availableYears.contains(year)) return;

    final newDate = DateTime(year, state.selectedMonth);

    emit(state.copyWith(selectedYear: year, focusedMonth: newDate));

    loadDate(newDate);
  }

  // ===============================
  // SELECT DATE (CLICK DAY)
  // ===============================
  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedYear: date.year,
        selectedMonth: date.month,
        focusedMonth: DateTime(date.year, date.month),
      ),
    );

    loadDate(date);
  }

  // ===============================
  // NEXT / PREVIOUS MONTH
  // ===============================
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

    loadDate(date);
  }

  // ===============================
  // LOAD DATE (HOLIDAY + EVENTS)
  // ===============================
  Future<void> loadDate(DateTime date) async {
    emit(state.copyWith(loading: true));

    final isHoliday = HolidayUtils.isHoliday(date, HolidayLocal.holidays);

    final holidayName = HolidayUtils.getHolidayName(
      date,
      HolidayLocal.holidays,
    );

    // 🔹 Dummy events (replace API later)
    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        selectedDate: date,
        events: const [
          CalendarEvent(
            title: "Mici’s Sick Leave",
            subtitle: "Not feeling well.",
            avatarUrl: "https://i.pravatar.cc/150?img=32",
          ),
          CalendarEvent(
            title: "Andrean’s Permission",
            subtitle: "Personal matter.",
            avatarUrl: "https://i.pravatar.cc/150?img=12",
          ),
        ],
        isHoliday: isHoliday,
        holidayName: holidayName,
        loading: false,
      ),
    );
  }
}
