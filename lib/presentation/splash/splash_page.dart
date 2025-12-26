import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Delay agar splash terlihat
    await Future.delayed(const Duration(milliseconds: 800));

    // Request permissions
    await _requestPermissions();

    if (!mounted) return;

    // 🔥 PINDAHKAN NAVIGASI KE POST FRAME
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/home');
    });
  }

  Future<void> _requestPermissions() async {
    final permissions = [Permission.locationWhenInUse, Permission.camera];

    for (final permission in permissions) {
      final status = await permission.status;
      if (status.isDenied) {
        await permission.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF624731);

    return Scaffold(
      backgroundColor: brown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 96, height: 96),
            const SizedBox(height: 24),
            const Text(
              'Absensi Karyawan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
