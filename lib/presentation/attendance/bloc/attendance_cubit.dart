import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository repository;

  AttendanceCubit({required this.repository})
    : super(AttendanceState.initial()) {
    loadAttendance();
  }

  // ===================================================
  // LOAD ATTENDANCE (DEFAULT: CURRENT MONTH)
  // ===================================================
  Future<void> loadAttendance() async {
    try {
      emit(state.copyWith(loading: true));

      final now = DateTime.now();

      // 🔹 attendance hari ini
      final todayAttendance = await repository.getTodayAttendance(now);

      // 🔹 history per bulan (default sekarang)
      final history = await repository.getAttendanceHistory(
        year: now.year,
        month: now.month,
      );

      emit(
        state.copyWith(
          loading: false,
          todayAttendance: todayAttendance,
          records: history,
          selectedYear: now.year,
          selectedMonth: now.month,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  // ===================================================
  // CHANGE MONTH & YEAR (FROM CALENDAR PICKER)
  // ===================================================
  Future<void> changeMonth({required int year, required int month}) async {
    try {
      emit(state.copyWith(loading: true));

      final history = await repository.getAttendanceHistory(
        year: year,
        month: month,
      );

      emit(
        state.copyWith(
          loading: false,
          records: history,
          selectedYear: year,
          selectedMonth: month,
          selectedDate: null,
          selectedHolidayName: null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  // ===================================================
  // SELECT DATE (FROM CALENDAR GRID)
  // ===================================================
  void selectDate({required DateTime date, String? holidayName}) {
    emit(state.copyWith(selectedDate: date, selectedHolidayName: holidayName));
  }

  // ===================================================
  // CHANGE FILTER
  // ===================================================
  void changeFilter(AttendanceFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  // ===================================================
  // CHECK IN
  // ===================================================
  Future<void> checkIn() async {
    try {
      emit(state.copyWith(actionLoading: true));

      final now = DateTime.now();

      final attendance = await repository.checkIn(now);

      emit(state.copyWith(actionLoading: false, todayAttendance: attendance));

      // reload history supaya sinkron
      await loadAttendance();
    } catch (_) {
      emit(state.copyWith(actionLoading: false));
    }
  }

  // ===================================================
  // CHECK OUT
  // ===================================================
  Future<void> checkOut() async {
    try {
      emit(state.copyWith(actionLoading: true));

      final now = DateTime.now();

      final attendance = await repository.checkOut(now);

      emit(state.copyWith(actionLoading: false, todayAttendance: attendance));

      // reload history supaya sinkron
      await loadAttendance();
    } catch (_) {
      emit(state.copyWith(actionLoading: false));
    }
  }

  // ===================================================
  // FILTERED RECORDS (FOR UI)
  // ===================================================
  List<AttendanceEntity> get filteredRecords {
    switch (state.filter) {
      case AttendanceFilter.onTime:
        return state.records.where((e) => e.isOnTime).toList();

      case AttendanceFilter.leave:
        return state.records.where((e) => e.isLeave).toList();

      case AttendanceFilter.holiday:
        return state.records.where((e) => e.isHoliday).toList();

      case AttendanceFilter.all:
        return state.records;
    }
  }
}
