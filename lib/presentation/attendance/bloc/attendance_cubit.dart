import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/holiday/holiday_service.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository repository;
  final HolidayService holidayService;

  AttendanceCubit({required this.repository, required this.holidayService})
    : super(AttendanceState.initial());

  // ===================================================
  // INIT (dipanggil dari router)
  // ===================================================
  Future<void> init() async {
    final now = DateTime.now();

    await loadAttendance(year: now.year, month: now.month);
    await loadTodayAttendance();
    await loadHolidays(now.year);
  }

  // ===================================================
  // LOAD HOLIDAYS
  // ===================================================
  Future<void> loadHolidays(int year) async {
    try {
      final holidays = await holidayService.getNationalHolidays(year);
      emit(state.copyWith(holidays: holidays));
    } catch (_) {
      // holiday optional → tidak crash
    }
  }

  // ===================================================
  // LOAD ATTENDANCE HISTORY
  // ===================================================
  Future<void> loadAttendance({required int year, required int month}) async {
    try {
      emit(state.copyWith(loading: true));

      final records = await repository.getAttendanceHistory(
        year: year,
        month: month,
      );

      emit(
        state.copyWith(
          loading: false,
          records: records,
          selectedYear: year,
          selectedMonth: month,
          clearSelectedDate: true,
          clearSelectedHoliday: true,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  // ===================================================
  // LOAD TODAY ATTENDANCE
  // ===================================================
  Future<void> loadTodayAttendance() async {
    try {
      final today = await repository.getTodayAttendance();
      emit(state.copyWith(todayAttendance: today));
    } catch (_) {}
  }

  // ===================================================
  // CHANGE MONTH
  // ===================================================
  Future<void> changeMonth({required int year, required int month}) async {
    emit(
      state.copyWith(
        selectedYear: year,
        selectedMonth: month,
        clearSelectedDate: true,
        clearSelectedHoliday: true,
      ),
    );

    await loadAttendance(year: year, month: month);
    await loadHolidays(year);
  }

  // ===================================================
  // SELECT DATE
  // ===================================================
  void selectDate(DateTime date, {String? holidayName}) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedHolidayName: holidayName,
        clearSelectedHoliday: holidayName == null,
      ),
    );
  }

  // ===================================================
  // CHANGE FILTER
  // ===================================================
  void changeFilter(AttendanceFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  // ===================================================
  // FILTERED RECORDS
  // ===================================================
  List<AttendanceEntity> get filteredRecords {
    final list = List<AttendanceEntity>.from(state.records);

    switch (state.filter) {
      case AttendanceFilter.onTime:
        return list.where((e) => e.isOnTime).toList();
      case AttendanceFilter.leave:
        return list.where((e) => e.isLeave).toList();
      case AttendanceFilter.holiday:
        return list.where((e) => e.isHoliday).toList();
      case AttendanceFilter.all:
        return list;
    }
  }

  // ===================================================
  // VISIBLE RECORDS
  // ===================================================
  List<AttendanceEntity> get visibleRecords {
    if (state.selectedDate == null) return filteredRecords;

    final d = state.selectedDate!;
    return filteredRecords
        .where(
          (e) =>
              e.date.year == d.year &&
              e.date.month == d.month &&
              e.date.day == d.day,
        )
        .toList();
  }
}
