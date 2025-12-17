import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/bloc/auth_cubit.dart';
import '../auth/bloc/otp_cubit.dart';
import '../auth/bloc/otp_purpose.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/otp_page.dart';
import '../auth/pages/reset_password_page.dart';
import '../auth/bloc/reset_password_cubit.dart';

import '../../domain/usecases/auth/otp_verify.dart';
import '../../domain/usecases/auth/reset_password.dart';

import '../home/pages/home_page.dart';
import '../profile/pages/profile_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/login',

      // ===============================
      // AUTH GUARD
      // ===============================
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;

        print('ROUTER STATE => $authState');

        final isLogin = location == '/login';
        final isOtp = location == '/otp';
        final isResetPassword = location == '/reset-password';

        // ===============================
        // ✅ SUDAH LOGIN → HOME (HARUS PALING ATAS)
        // ===============================
        if (authState is AuthAuthenticated) {
          if (isLogin || isOtp || isResetPassword) {
            return '/home';
          }
          return null;
        }

        // ===============================
        // OTP REQUIRED
        // ===============================
        if (authState is AuthOtpRequired) {
          if (isOtp) return null;
          return '/otp';
        }

        // ===============================
        // BELUM LOGIN
        // ===============================
        if (authState is AuthUnauthenticated || authState is AuthInitial) {
          if (isLogin || isResetPassword) return null;
          return '/login';
        }

        return null;
      },

      routes: [
        // ===============================
        // LOGIN
        // ===============================
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),

        // ===============================
        // OTP
        // ===============================
        GoRoute(
          path: '/otp',
          name: 'otp',
          builder: (context, state) {
            final authState = context.read<AuthCubit>().state;

            if (authState is! AuthOtpRequired) {
              return const LoginPage();
            }

            return BlocProvider<OtpCubit>(
              create: (context) => OtpCubit(context.read<OtpVerify>()),
              child: OtpPage(email: authState.email, purpose: OtpPurpose.login),
            );
          },
        ),

        // ===============================
        // RESET PASSWORD
        // ===============================
        GoRoute(
          path: '/reset-password',
          name: 'reset-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            if (extra == null || !extra.containsKey('email')) {
              return const LoginPage();
            }

            return BlocProvider(
              create: (context) =>
                  ResetPasswordCubit(context.read<ResetPassword>()),
              child: ResetPasswordPage(email: extra['email'] as String),
            );
          },
        ),

        // ===============================
        // HOME
        // ===============================
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        // ===============================
        // PROFILE
        // ===============================
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    );
  }
}
