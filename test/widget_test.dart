import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:absensi_karyawan_app/main.dart';
import 'package:absensi_karyawan_app/core/services/device/local_storage_service.dart';
import 'package:absensi_karyawan_app/presentation/auth/bloc/auth_cubit.dart';
import 'package:absensi_karyawan_app/data/repositories/auth_repository_impl.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/auth_remote.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Dummy dependencies
    final storage = LocalStorageService();
    final authCubit = AuthCubit(storage);

    final dio = Dio();
    final authRemote = AuthRemote(dio);
    final authRepository = AuthRepositoryImpl(authRemote);

    // Build app
    await tester.pumpWidget(
      AbsensiApp(
        authRepository: authRepository,
        authCubit: authCubit, // ✅ FIX
      ),
    );

    // Verify app builds
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
