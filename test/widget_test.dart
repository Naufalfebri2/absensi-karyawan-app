import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absensi_karyawan_app/main.dart';

// ===============================
// MOCK / DUMMY
// ===============================
import 'package:absensi_karyawan_app/data/repositories/auth_repository_impl.dart';
import 'package:absensi_karyawan_app/data/repositories/leave_repository_impl.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/auth_remote.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/leave_remote.dart';
import 'package:absensi_karyawan_app/core/network/dio_client.dart';
import 'package:absensi_karyawan_app/core/services/device/local_storage_service.dart';
import 'package:absensi_karyawan_app/presentation/auth/bloc/auth_cubit.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final storage = LocalStorageService();
    DioClient.setupInterceptors(storage);
    final dio = DioClient.instance;

    final authRepository = AuthRepositoryImpl(AuthRemote(dio));
    final leaveRepository = LeaveRepositoryImpl(LeaveRemote(dio));
    final authCubit = AuthCubit(storage);

    await tester.pumpWidget(
      AbsensiApp(
        authRepository: authRepository,
        leaveRepository: leaveRepository,
        authCubit: authCubit,
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
