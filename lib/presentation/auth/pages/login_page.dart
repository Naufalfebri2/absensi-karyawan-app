import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:absensi_karyawan_app/config/constants/app_image.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // ===== TOP GRADIENT (Figma akurat) =====
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
                    stops: [0.02, 0.51, 1.0],
                  ),
                ),
              ),

              // ============ CARD PUTIH ============ //
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocListener<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      // Pindah ke OTP Page sambil bawa data
                      context.go('/otp', extra: {
                        'user_id': state.userId,
                        'temp_token': state.tempToken,
                      });
                    }

                    if (state is LoginError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: size.height * 0.21, // CARD naik mendekati logo
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 30),
                          LoginForm(), // <-- tombol login ada di dalam
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ============ LOGO DI ATAS CARD ============ //
              Positioned(
                top: size.height * 0.09,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 123,
                    height: 123,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
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
      ),
    );
  }
}
