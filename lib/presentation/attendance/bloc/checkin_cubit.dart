import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/location/location_service.dart';
import '../../../core/utils/distance_utils.dart';

import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/office_location_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';
import '../../../domain/usecases/attendance/get_today_attendance.dart';

import 'checkin_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit({
    required LocationService locationService,
    required GetTodayAttendance getTodayAttendance,
    required AttendanceRepository attendanceRepository,
  }) : _locationService = locationService,
       _getTodayAttendance = getTodayAttendance,
       _attendanceRepository = attendanceRepository,
       super(const CheckInInitial());

  final LocationService _locationService;
  final GetTodayAttendance _getTodayAttendance;
  final AttendanceRepository _attendanceRepository;

  // ===============================
  // DEFAULT SHIFT
  // ===============================
  final ShiftEntity _shift = ShiftEntity.defaultShift();

  // ===============================
  // OFFICE LOCATION
  // ===============================
  final OfficeLocationEntity _office = OfficeLocationEntity.defaultOffice();

  // ===============================
  // SUBMIT CHECK IN (🔥 + SELFIE)
  // ===============================
  Future<void> submitCheckIn({required File selfieFile}) async {
    emit(const CheckInLoading());

    try {
      // ===============================
      // 0️⃣ SELFIE VALIDATION (WAJIB)
      // ===============================
      if (!await selfieFile.exists()) {
        emit(const CheckInFailure('Invalid selfie photo'));
        return;
      }

      final now = DateTime.now();

      // ===================================================
      // 🔒 HARD GUARD: ALREADY CHECKED OUT TODAY
      // ===================================================
      final todayAttendance = await _getTodayAttendance();

      if (todayAttendance != null && todayAttendance.hasCheckOut) {
        emit(const CheckInFailure('You have already checked out today'));
        return;
      }

      // ===============================
      // 1️⃣ GPS VALIDATION
      // ===============================
      final userLatLng = await _locationService.getLatLng();

      final distance = DistanceUtils.distanceInMeters(
        lat1: userLatLng.latitude,
        lon1: userLatLng.longitude,
        lat2: _office.latitude,
        lon2: _office.longitude,
      );

      if (distance > _office.radiusMeter) {
        emit(
          const CheckInFailure(
            'You are not within the designated GPS location',
          ),
        );
        return;
      }

      // ===============================
      // 2️⃣ STATUS CHECK IN
      // ===============================
      final AttendanceStatus status = _shift.isLate(now)
          ? AttendanceStatus.late
          : AttendanceStatus.onTime;

      // ===============================
      // 🔥 SAVE TO REPOSITORY
      // ===============================
      await _attendanceRepository.saveCheckIn(
        time: now,
        status: status,
        selfiePath: selfieFile.path,
        latitude: userLatLng.latitude,
        longitude: userLatLng.longitude,
      );

      emit(CheckInSuccess(status: status, checkInTime: now));
    } on LocationException catch (e) {
      emit(CheckInFailure(e.message));
    } catch (e) {
      emit(CheckInFailure(e.toString()));
    }
  }

  // ===============================
  // RESET
  // ===============================
  void reset() {
    emit(const CheckInInitial());
  }
}
