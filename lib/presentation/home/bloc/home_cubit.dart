import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/holiday/holiday_service.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/utils/distance_utils.dart';

import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/office_location_entity.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HolidayService holidayService;
  final LocationService locationService;

  HomeCubit({required this.holidayService, required this.locationService})
    : super(HomeInitial());

  Timer? _timer;
  bool _hasCheckedIn = false;

  // ===============================
  // DEFAULT SHIFT (08:00 - 17:00)
  // ===============================
  final ShiftEntity _shift = ShiftEntity.defaultShift();

  // ===============================
  // OFFICE LOCATION (100m)
  // ===============================
  final OfficeLocationEntity _office = OfficeLocationEntity.defaultOffice();

  // ===============================
  // HOLIDAY CACHE
  // ===============================
  Map<DateTime, String> _holidayCache = {};

  // ===============================
  // LOAD DASHBOARD
  // ===============================
  Future<void> loadDashboard() async {
    final now = DateTime.now();

    _holidayCache = await holidayService.getNationalHolidays(now.year);

    await _emitHomeData();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _emitHomeData();
    });
  }

  // ===============================
  // EMIT HOME STATE
  // ===============================
  Future<void> _emitHomeData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ===============================
    // HOLIDAY CHECK
    // ===============================
    final holidayName = _holidayCache[today];
    final isHoliday = holidayName != null;

    bool canCheckIn = false;
    bool canCheckOut = false;
    bool isWithinOfficeRadius = false;
    double? distanceFromOffice;
    String? restrictionMessage;
    String? gpsErrorMessage;

    // ===============================
    // GPS VALIDATION (PRIORITY)
    // ===============================
    try {
      final userLocation = await locationService.getLatLng();

      distanceFromOffice = DistanceUtils.distanceInMeters(
        lat1: userLocation.latitude,
        lon1: userLocation.longitude,
        lat2: _office.latitude,
        lon2: _office.longitude,
      );

      isWithinOfficeRadius = distanceFromOffice <= _office.radiusMeter;

      if (!isWithinOfficeRadius) {
        restrictionMessage =
            'Anda berada di luar radius kantor (${DistanceUtils.formatDistance(distanceFromOffice)})';
      }
    } catch (e) {
      gpsErrorMessage = e.toString();
      restrictionMessage = gpsErrorMessage;
    }

    // ===============================
    // TIME & HOLIDAY VALIDATION
    // ===============================
    if (restrictionMessage == null) {
      if (isHoliday) {
        restrictionMessage = 'Hari libur nasional';
      } else {
        if (!_hasCheckedIn) {
          if (_shift.canCheckIn(now)) {
            canCheckIn = true;
          } else {
            final shiftStart = _shift.getStartDateTime(now);
            final lateLimit = shiftStart.add(
              Duration(minutes: _shift.toleranceMinutes),
            );

            if (now.isBefore(shiftStart)) {
              restrictionMessage = 'Belum masuk jam kerja';
            } else if (now.isAfter(lateLimit)) {
              restrictionMessage = 'Sudah melewati batas Check In';
            }
          }
        } else {
          if (_shift.canCheckOut(now)) {
            canCheckOut = true;
          } else {
            restrictionMessage = 'Belum waktunya Check Out';
          }
        }
      }
    }

    emit(
      HomeLoaded(
        pendingLeaveCount: 0,
        now: now,
        locationName: 'Universitas Pamulang, Tangerang Selatan',
        hasCheckedIn: _hasCheckedIn,
        isHoliday: isHoliday,
        holidayName: holidayName,
        canCheckIn: canCheckIn,
        canCheckOut: canCheckOut,
        isWithinOfficeRadius: isWithinOfficeRadius,
        distanceFromOffice: distanceFromOffice,
        gpsErrorMessage: gpsErrorMessage,
        restrictionMessage: restrictionMessage,
      ),
    );
  }

  // ===============================
  // UI TOGGLE
  // ===============================
  void markCheckedIn() {
    _hasCheckedIn = true;
    _emitHomeData();
  }

  void markCheckedOut() {
    _hasCheckedIn = false;
    _emitHomeData();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
