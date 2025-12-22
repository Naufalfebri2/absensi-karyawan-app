import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_state.dart';
import '../../../data/datasources/local/holiday_local.dart';
import '../../../core/utils/holiday_utils.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial()) {
    loadDate(DateTime.now());
  }

  // ===============================
  // CHANGE MONTH
  // ===============================
  void changeMonth(DateTime month) {
    emit(state.copyWith(focusedMonth: month));
  }

  // ===============================
  // SELECT DATE
  // ===============================
  void selectDate(DateTime date) {
    loadDate(date);
  }

  // ===============================
  // LOAD DATE (HOLIDAY + EVENTS)
  // ===============================
  Future<void> loadDate(DateTime date) async {
    emit(state.copyWith(selectedDate: date, loading: true));

    // 🔥 HOLIDAY LOGIC (ONCE)
    final isHoliday = HolidayUtils.isHoliday(date, HolidayLocal.holidays);

    final holidayName = HolidayUtils.getHolidayName(
      date,
      HolidayLocal.holidays,
    );

    // 🔹 Dummy events (replace API later)
    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        events: [
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
        loading: false,
        isHoliday: isHoliday,
        holidayName: holidayName, // 🔥 TIDAK AKAN KE-RESET
      ),
    );
  }
}
