import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absensi_karyawan_app/main.dart';

// ===============================
// DATA
// ===============================
import 'package:absensi_karyawan_app/data/repositories/auth_repository_impl.dart';
import 'package:absensi_karyawan_app/data/repositories/leave_repository_impl.dart';
import 'package:absensi_karyawan_app/data/repositories/attendance_repository_impl.dart';

import 'package:absensi_karyawan_app/data/datasources/remote/auth_remote.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/leave_remote.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/attendance_remote.dart';

// ===============================
// CORE
// ===============================
import 'package:absensi_karyawan_app/core/network/dio_client.dart';
import 'package:absensi_karyawan_app/core/services/device/local_storage_service.dart';
import 'package:absensi_karyawan_app/core/services/holiday/holiday_service.dart';

// ===============================
// CUBIT
// ===============================
import 'package:absensi_karyawan_app/presentation/auth/bloc/auth_cubit.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // ===============================
    // CORE
    // ===============================
    final storage = LocalStorageService();
    DioClient.setupInterceptors(storage);
    final dio = DioClient.instance;

    // ===============================
    // AUTH
    // ===============================
    final authRepository = AuthRepositoryImpl(AuthRemote(dio));

    // ===============================
    // LEAVE
    // ===============================
    final leaveRepository = LeaveRepositoryImpl(LeaveRemote(dio));

    // ===============================
    // ATTENDANCE
    // ===============================
    final attendanceRepository = AttendanceRepositoryImpl(
      remoteDataSource: AttendanceRemote(dio),
    );

    // ===============================
    // HOLIDAY SERVICE ✅ WAJIB
    // ===============================
    final holidayService = HolidayService();

    // ===============================
    // AUTH CUBIT
    // ===============================
    final authCubit = AuthCubit(storage);

    // ===============================
    // PUMP APP
    // ===============================
    await tester.pumpWidget(
      AbsensiApp(
        authRepository: authRepository,
        leaveRepository: leaveRepository,
        attendanceRepository: attendanceRepository,
        holidayService: holidayService, // ✅ FIX
        authCubit: authCubit,
      ),
    );

    // ===============================
    // BASIC ASSERT
    // ===============================
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
