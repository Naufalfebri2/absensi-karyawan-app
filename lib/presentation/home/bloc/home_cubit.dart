import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/holiday/holiday_service.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/utils/distance_utils.dart';

import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/office_location_entity.dart';
import '../../../domain/usecases/attendance/get_today_attendance.dart';
// 🔥 NEW (optional – nanti bisa diganti API khusus summary)
// import '../../../domain/usecases/attendance/get_monthly_attendance.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HolidayService holidayService;
  final LocationService locationService;
  final GetTodayAttendance getTodayAttendance;
  // 🔥 NEW (optional)
  // final GetMonthlyAttendance getMonthlyAttendance;

  HomeCubit({
    required this.holidayService,
    required this.locationService,
    required this.getTodayAttendance,
    // required this.getMonthlyAttendance,
  }) : super(const HomeInitial());

  // ===============================
  // TIMERS
  // ===============================
  Timer? _clockTimer;
  Timer? _gpsTimer;

  // ===============================
  // ATTENDANCE STATE
  // ===============================
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;

  // ===============================
  // STATIC CONFIG
  // ===============================
  final ShiftEntity _shift = ShiftEntity.defaultShift();
  final OfficeLocationEntity _office = OfficeLocationEntity.defaultOffice();

  // ===============================
  // CACHE
  // ===============================
  Map<DateTime, String> _holidayCache = {};
  double? _distanceFromOffice;
  String? _gpsErrorMessage;

  // ===============================
  // 🔥 MONTHLY SUMMARY CACHE (NEW)
  // ===============================
  int _presentCount = 0;
  int _lateCount = 0;
  int _absentCount = 0;
  int _overtimeCount = 0;

  // ===============================
  // LOAD DASHBOARD (INIT)
  // ===============================
  Future<void> loadDashboard() async {
    emit(const HomeLoading());

    await _loadTodayFromSource();
    await _loadMonthlySummary(); // 🔥 NEW

    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _emitHomeState(DateTime.now()),
    );

    _gpsTimer?.cancel();
    _gpsTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await _updateGps();
      _emitHomeState(DateTime.now());
    });
  }

  // ===============================
  // 🔥 AUTO REFRESH HOME
  // ===============================
  Future<void> refresh() async {
    await _loadTodayFromSource();
    await _loadMonthlySummary(); // 🔥 NEW
    _emitHomeState(DateTime.now());
  }

  // ===============================
  // 🔒 ENSURE AUTO REFRESH
  // ===============================
  void ensureAutoRefresh() {
    if (_clockTimer == null || !_clockTimer!.isActive) {
      _clockTimer?.cancel();
      _clockTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _emitHomeState(DateTime.now()),
      );
    }
  }

  // ===============================
  // LOAD TODAY (SINGLE SOURCE)
  // ===============================
  Future<void> _loadTodayFromSource() async {
    final now = DateTime.now();

    final todayAttendance = await getTodayAttendance();

    // 🔥 DEBUG LOGGING
    print('🔍 [HomeCubit] getTodayAttendance result: $todayAttendance');

    if (todayAttendance != null) {
      _hasCheckedIn = todayAttendance.hasCheckIn;
      _hasCheckedOut = todayAttendance.hasCheckOut;

      // 🔥 DEBUG LOGGING
      print('🔍 [HomeCubit] hasCheckIn: $_hasCheckedIn');
      print('🔍 [HomeCubit] hasCheckOut: $_hasCheckedOut');
      print('🔍 [HomeCubit] checkInTime: ${todayAttendance.checkInTime}');
      print('🔍 [HomeCubit] checkOutTime: ${todayAttendance.checkOutTime}');
      // } else {
      //   _hasCheckedIn = false;
      //   _hasCheckedOut = false;

      // 🔥 DEBUG LOGGING
      print('🔍 [HomeCubit] No attendance data for today');
    }

    _holidayCache = await holidayService.getNationalHolidays(now.year);

    await _updateGps();
  }

  // ===============================
  // 🔥 LOAD MONTHLY SUMMARY (NEW)
  // ===============================
  Future<void> _loadMonthlySummary() async {
    try {
      // ⚠️ SEMENTARA HARD-CODE / PLACEHOLDER
      // Jika backend sudah siap:
      // final data = await getMonthlyAttendance();
      // lalu aggregate di sini

      _presentCount = 18;
      _lateCount = 3;
      _absentCount = 1;
      _overtimeCount = 2;
    } catch (_) {
      _presentCount = 0;
      _lateCount = 0;
      _absentCount = 0;
      _overtimeCount = 0;
    }
  }

  // ===============================
  // UPDATE GPS
  // ===============================
  Future<void> _updateGps() async {
    try {
      final userLocation = await locationService.getLatLng();

      _distanceFromOffice = DistanceUtils.distanceInMeters(
        lat1: userLocation.latitude,
        lon1: userLocation.longitude,
        lat2: _office.latitude,
        lon2: _office.longitude,
      );

      _gpsErrorMessage = null;
    } catch (e) {
      _distanceFromOffice = null;
      _gpsErrorMessage = e.toString();
    }
  }

  // ===============================
  // EMIT HOME STATE (FINAL)
  // ===============================
  void _emitHomeState(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);

    final holidayName = _holidayCache[today];
    final isHoliday = holidayName != null;

    final isWithinOfficeRadius =
        _distanceFromOffice != null &&
        _distanceFromOffice! <= _office.radiusMeter;

    bool canCheckIn = false;
    bool canCheckOut = false;
    String? restrictionMessage;

    // 🔥 GUARD CLAUSES (Priority Order)
    if (_gpsErrorMessage != null) {
      restrictionMessage = 'GPS is not available';
    } else if (_hasCheckedOut) {
      restrictionMessage = 'You have already checked out today';
    } else if (isHoliday) {
      restrictionMessage = 'National holiday: $holidayName';
    } else if (!isWithinOfficeRadius) {
      // 🔒 NEW: Block check-in if outside radius
      restrictionMessage = 'You are outside the office radius';
    } else {
      // ✅ VALID STATE (Inside Radius, Not Holiday, GPS OK)
      if (!_hasCheckedIn) {
        canCheckIn = true;

        final shiftStart = _shift.getStartDateTime(now);
        final lateLimit = shiftStart.add(
          Duration(minutes: _shift.toleranceMinutes),
        );

        if (now.isBefore(shiftStart)) {
          restrictionMessage = 'Working hours have not started yet';
        } else if (now.isAfter(lateLimit)) {
          restrictionMessage = 'You checked in late';
        }
      } else {
        if (_shift.canCheckOut(now)) {
          canCheckOut = true;
        } else {
          restrictionMessage = 'It is not time to check out yet';
        }
      }
    }

    emit(
      HomeLoaded(
        pendingLeaveCount: 0,
        now: now,
        locationName: 'Universitas Pamulang, South Tangerang',
        hasCheckedIn: _hasCheckedIn,
        hasCheckedOut: _hasCheckedOut,
        isHoliday: isHoliday,
        holidayName: holidayName,
        canCheckIn: canCheckIn,
        canCheckOut: canCheckOut,
        restrictionMessage: restrictionMessage,
        isWithinOfficeRadius: isWithinOfficeRadius,
        distanceFromOffice: _distanceFromOffice,
        gpsErrorMessage: _gpsErrorMessage,

        // 🔥 NEW SUMMARY DATA
        presentCount: _presentCount,
        lateCount: _lateCount,
        absentCount: _absentCount,
        overtimeCount: _overtimeCount,
      ),
    );
  }

  // ===============================
  // UI OPTIMIZATION
  // ===============================
  void markCheckedIn() {
    _hasCheckedIn = true;
    _hasCheckedOut = false;
    _emitHomeState(DateTime.now());
  }

  void markCheckedOut() {
    _hasCheckedIn = true; // 🔥 FIX: Keep checked in state
    _hasCheckedOut = true;
    _emitHomeState(DateTime.now());
  }

  @override
  Future<void> close() {
    _clockTimer?.cancel();
    _gpsTimer?.cancel();
    return super.close();
  }
}
