// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'package:absensi_karyawan_app/main.dart';
import 'package:absensi_karyawan_app/data/repositories/auth_repository_impl.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/auth_remote.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Create dummy dependencies for testing
    final dio = Dio();
    final authRemote = AuthRemote(dio);
    final authRepository = AuthRepositoryImpl(authRemote);

    // Build our app and trigger a frame.
    await tester.pumpWidget(AbsensiApp(authRepository: authRepository));

    // Verify that our app builds without errors
    expect(find.byType(AbsensiApp), findsOneWidget);
  });
}
