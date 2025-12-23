import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:absensi_karyawan_app/config/constants/app_image.dart';
import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';
import '../widgets/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  // ===============================
  // HELPER: MASK EMAIL
  // ===============================
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) return '***@$domain';
    return '${name.substring(0, 2)}****@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Stack(
          children: [
            // ===============================
            // TOP GRADIENT (SAMA LOGIN)
            // ===============================
            Container(
              height: size.height * 0.42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF37210E),
                    Color(0xFF624731),
                    Color(0xFF957158),
                  ],
                ),
              ),
            ),

            // ===============================
            // CARD (IDENTIK LOGIN)
            // ===============================
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
                listener: (context, state) async {
                  if (state is ResetPasswordError) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }

                  if (state is ResetPasswordSuccess) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: const Text('Berhasil'),
                        content: const Text(
                          'Password berhasil direset.\nSilakan login kembali.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/login');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    top: size.height * 0.28, // ✅ SAMA LOGIN
                    bottom: 16,
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 35, // ✅ SAMA LOGIN
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Buat password baru untuk\n${_maskEmail(email)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF797979),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ===============================
                      // FORM (SCROLL SAFE)
                      // ===============================
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: ResetPasswordForm(email: email),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===============================
            // LOGO (SAMA LOGIN)
            // ===============================
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.asset(AppImages.logo, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
