import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/holiday/holiday_service.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import 'attendance_state.dart';
import '../utils/attendance_status_mapper.dart';

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

    // urutan aman
    await loadHolidays(now.year);
    await loadAttendance(year: now.year, month: now.month);
    await loadTodayAttendance();
  }

  // ===================================================
  // LOAD HOLIDAYS
  // ===================================================
  Future<void> loadHolidays(int year) async {
    try {
      final holidays = await holidayService.getNationalHolidays(year);
      emit(state.copyWith(holidays: holidays));
    } catch (_) {
      // silent fail, UI tidak crash
    }
  }

  // ===================================================
  // LOAD ATTENDANCE HISTORY (PER BULAN + STATUS API)
  // ===================================================
  Future<void> loadAttendance({required int year, required int month}) async {
    emit(state.copyWith(loading: true));

    try {
      // 🔥 MAP FILTER UI → STATUS API
      final apiStatus = mapAttendanceFilterToApiStatus(state.filter);

      final records = await repository.getAttendanceHistory(
        year: year,
        month: month,
        status: apiStatus,
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
    } catch (_) {
      // optional logging
    }
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

    await loadHolidays(year);
    await loadAttendance(year: year, month: month);
  }

  // ===================================================
  // SELECT DATE (CALENDAR → LIST)
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
  // CHANGE FILTER (🔥 TRIGGER API RELOAD)
  // ===================================================
  Future<void> changeFilter(AttendanceFilter filter) async {
    emit(state.copyWith(filter: filter));

    // 🔥 reload data dari API sesuai filter baru
    await loadAttendance(year: state.selectedYear, month: state.selectedMonth);
  }

  // ===================================================
  // SYNC AFTER CHECK IN
  // ===================================================
  void syncAfterCheckIn({
    required DateTime checkInTime,
    required AttendanceStatus status,
  }) {
    final today = _normalizeDate(checkInTime);
    final formattedTime = _formatTime(checkInTime);

    final updatedToday = state.todayAttendance?.copyWith(
      checkInTime: formattedTime,
      status: status,
    );

    final updatedRecords = state.records.map((e) {
      if (_isSameDate(e.date, today)) {
        return e.copyWith(checkInTime: formattedTime, status: status);
      }
      return e;
    }).toList();

    emit(
      state.copyWith(todayAttendance: updatedToday, records: updatedRecords),
    );
  }

  // ===================================================
  // SYNC AFTER CHECK OUT
  // ===================================================
  void syncAfterCheckOut({required DateTime checkOutTime}) {
    final today = _normalizeDate(checkOutTime);
    final formattedTime = _formatTime(checkOutTime);

    final updatedToday = state.todayAttendance?.copyWith(
      checkOutTime: formattedTime,
    );

    final updatedRecords = state.records.map((e) {
      if (_isSameDate(e.date, today)) {
        return e.copyWith(checkOutTime: formattedTime);
      }
      return e;
    }).toList();

    emit(
      state.copyWith(todayAttendance: updatedToday, records: updatedRecords),
    );
  }

  // ===================================================
  // FILTERED RECORDS (CLIENT SIDE – SAFETY)
  // ===================================================
  List<AttendanceEntity> get filteredRecords {
    final list = List<AttendanceEntity>.from(state.records);

    switch (state.filter) {
      case AttendanceFilter.onTime:
        return list.where((e) => e.isOnTime || e.isLate).toList();
      case AttendanceFilter.leave:
        return list.where((e) => e.isLeave).toList();
      case AttendanceFilter.holiday:
        return list.where((e) => e.isHoliday).toList();
      case AttendanceFilter.all:
        return list;
    }
  }

  // ===================================================
  // VISIBLE RECORDS (FILTER + SELECTED DATE)
  // ===================================================
  List<AttendanceEntity> get visibleRecords {
    if (state.selectedDate == null) return filteredRecords;

    final d = state.selectedDate!;
    return filteredRecords.where((e) => _isSameDate(e.date, d)).toList();
  }

  // ===================================================
  // HELPERS
  // ===================================================
  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}
