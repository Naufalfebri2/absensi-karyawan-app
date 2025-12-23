import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:absensi_karyawan_app/config/constants/app_image.dart';
import 'package:absensi_karyawan_app/config/theme/app_colors.dart';

import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';
import '../bloc/otp_purpose.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ================= TOP GRADIENT =================
            Container(
              height: size.height * 0.42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary, // #624731
                    Color(0xFF7A5A44), // mid brown
                    Color(0xFF9B7A63), // soft brown
                  ],
                ),
              ),
            ),

            // ================= CARD =================
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            'Kode OTP dikirim ke ${_maskEmail(state.email)}',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.success,
                        ),
                      );

                    context.go(
                      '/otp',
                      extra: {
                        'email': state.email,
                        'purpose': OtpPurpose.forgotPassword,
                      },
                    );
                  }

                  if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.danger,
                        ),
                      );
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    top: size.height * 0.28,
                    bottom: 16,
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Account Verification',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Provide your account email to reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF797979),
                        ),
                      ),
                      SizedBox(height: 48),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ForgotPasswordForm(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================= LOGO =================
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Image.asset(AppImages.logo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
