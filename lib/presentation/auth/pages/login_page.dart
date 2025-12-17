import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

import 'package:absensi_karyawan_app/config/constants/app_image.dart';
import '../../../domain/usecases/auth/login_user.dart';

// WAJIB
import '../bloc/auth_cubit.dart';

import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
// import '../bloc/otp_purpose.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<LoginUser>()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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
                        Color(0xFF37210E),
                        Color(0xFF624731),
                        Color(0xFF957158),
                      ],
                    ),
                  ),
                ),

                // ================= CARD =================
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocListener<LoginCubit, LoginState>(
                    listenWhen: (prev, curr) =>
                        curr is LoginOtpRequired || curr is LoginError,
                    listener: (context, state) {
                      if (!context.mounted) return;

                      // OGIN VALID → OTP
                      if (state is LoginOtpRequired) {
                        context.read<AuthCubit>().requireOtp(
                          email: state.email,
                        );
                      }

                      // ERROR LOGIN
                      if (state is LoginError) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        left: 2,
                        right: 2,
                        top: size.height * 0.21,
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: const [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 60),
                          Expanded(
                            child: SingleChildScrollView(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              child: LoginForm(),
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
                    child: Container(
                      width: 123,
                      height: 123,
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
        ),
      ),
    );
  }
}
