import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/holiday/holiday_service.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/utils/distance_utils.dart';

import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/office_location_entity.dart';
import '../../../domain/usecases/attendance/get_today_attendance.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HolidayService holidayService;
  final LocationService locationService;
  final GetTodayAttendance getTodayAttendance;

  HomeCubit({
    required this.holidayService,
    required this.locationService,
    required this.getTodayAttendance,
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
  // LOAD DASHBOARD (INIT)
  // ===============================
  Future<void> loadDashboard() async {
    emit(const HomeLoading());

    await _loadTodayFromSource();

    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _emitHomeState(DateTime.now()),
    );

    _gpsTimer?.cancel();
    _gpsTimer = Timer.periodic(const Duration(seconds: 1000), (_) async {
      await _updateGps();
      _emitHomeState(DateTime.now());
    });
  }

  // ===============================
  // 🔥 AUTO REFRESH HOME (BARU)
  // ===============================
  Future<void> refresh() async {
    await _loadTodayFromSource();
    _emitHomeState(DateTime.now());
  }

  // ===============================
  // 🔒 ENSURE AUTO REFRESH (SAFE GUARD)
  // ===============================
  void ensureAutoRefresh() {
    // Jika timer jam belum aktif (misal setelah pindah tab),
    // aktifkan kembali TANPA reload API
    if (_clockTimer == null || !_clockTimer!.isActive) {
      _clockTimer?.cancel();
      _clockTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _emitHomeState(DateTime.now()),
      );
    }
  }

  // ===============================
  // LOAD TODAY FROM SOURCE (SINGLE SOURCE OF TRUTH)
  // ===============================
  Future<void> _loadTodayFromSource() async {
    final now = DateTime.now();

    final todayAttendance = await getTodayAttendance();
    if (todayAttendance != null) {
      _hasCheckedIn = todayAttendance.hasCheckIn;
      _hasCheckedOut = todayAttendance.hasCheckOut;
    } else {
      _hasCheckedIn = false;
      _hasCheckedOut = false;
    }

    _holidayCache = await holidayService.getNationalHolidays(now.year);

    await _updateGps();
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
  // EMIT HOME STATE (FINAL LOGIC)
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

    if (_gpsErrorMessage != null) {
      restrictionMessage = 'GPS is not available';
    } else if (_hasCheckedOut) {
      restrictionMessage = 'You have already checked out today';
    } else if (isHoliday) {
      restrictionMessage = 'National holiday: $holidayName';
    } else {
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

    if (!isWithinOfficeRadius && restrictionMessage == null) {
      restrictionMessage = 'You are outside the office radius';
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
      ),
    );
  }

  // ===============================
  // UI OPTIMIZATION (OPTIONAL)
  // ===============================
  void markCheckedIn() {
    _hasCheckedIn = true;
    _hasCheckedOut = false;
    _emitHomeState(DateTime.now());
  }

  void markCheckedOut() {
    _hasCheckedIn = false;
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
