import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/location/location_service.dart';
import '../../../core/utils/distance_utils.dart';

import '../../../domain/entities/shift_entity.dart';
import '../../../domain/entities/office_location_entity.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/repositories/attendance_repository.dart';

import 'checkout_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit({
    required LocationService locationService,
    required AttendanceRepository attendanceRepository,
  }) : _locationService = locationService,
       _attendanceRepository = attendanceRepository,
       super(const CheckOutInitial());

  final LocationService _locationService;
  final AttendanceRepository _attendanceRepository;

  // ===============================
  // INTERNAL GUARD
  // ===============================
  bool _isSubmitting = false;

  // ===============================
  // DEFAULT SHIFT
  // ===============================
  final ShiftEntity _shift = ShiftEntity.defaultShift();

  // ===============================
  // OFFICE LOCATION
  // ===============================
  final OfficeLocationEntity _office = OfficeLocationEntity.defaultOffice();

  // ===============================
  // SUBMIT CHECK OUT (🔥 WAJIB SELFIE)
  // ===============================
  Future<void> submitCheckOut({required File selfieFile}) async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    emit(const CheckOutLoading());

    try {
      final now = DateTime.now();

      // ===============================
      // 0️⃣ SELFIE VALIDATION (WAJIB)
      // ===============================
      if (!await selfieFile.exists()) {
        emit(const CheckOutFailure('Selfie tidak valid'));
        return;
      }

      // ===============================
      // 1️⃣ SHIFT VALIDATION
      // ===============================
      if (!_shift.canCheckOut(now)) {
        emit(const CheckOutFailure('Belum waktunya Check Out'));
        return;
      }

      // ===============================
      // 2️⃣ GPS VALIDATION
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
          const CheckOutFailure(
            'Anda tidak berada di lokasi GPS yang ditentukan',
          ),
        );
        return;
      }

      // ===============================
      // 3️⃣ STATUS CHECK OUT
      // ===============================
      AttendanceStatus status = AttendanceStatus.onTime;

      if (_shift.isEarlyLeave(now)) {
        status = AttendanceStatus.earlyLeave;
      } else if (_shift.isOvertime(now)) {
        status = AttendanceStatus.overtime;
      }

      // ===============================
      // 🔥 SAVE TO REPOSITORY
      // ===============================
      await _attendanceRepository.saveCheckOut(
        time: now,
        status: status,
        selfiePath: selfieFile.path,
      );

      emit(CheckOutSuccess(status: status, checkOutTime: now));
    } on LocationException catch (e) {
      emit(CheckOutFailure(e.message));
    } catch (_) {
      emit(const CheckOutFailure('Gagal melakukan Check Out'));
    } finally {
      _isSubmitting = false;
    }
  }

  // ===============================
  // RESET
  // ===============================
  void reset() {
    _isSubmitting = false;
    emit(const CheckOutInitial());
  }
}
