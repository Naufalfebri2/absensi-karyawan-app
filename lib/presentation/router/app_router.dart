import 'package:go_router/go_router.dart';

import '../auth/bloc/auth_cubit.dart';
import '../auth/bloc/otp_purpose.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/otp_page.dart';
import '../auth/pages/reset_password_page.dart';
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

        final isLogin = location == '/login';
        final isOtp = location == '/otp';
        final isResetPassword = location == '/reset-password';

        // ===============================
        // SUDAH LOGIN
        // ===============================
        if (authState is AuthAuthenticated) {
          if (isLogin || isOtp) {
            return '/home';
          }
          return null;
        }

        // ===============================
        // BELUM LOGIN
        // ===============================
        if (authState is AuthUnauthenticated || authState is AuthInitial) {
          // 🔥 IZINKAN LOGIN, OTP, RESET PASSWORD
          if (isLogin || isOtp || isResetPassword) {
            return null;
          }
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
        // OTP (LOGIN / FORGOT PASSWORD)
        // ===============================
        GoRoute(
          path: '/otp',
          name: 'otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            // 🛡️ VALIDASI DATA OTP
            if (extra == null ||
                !extra.containsKey('email') ||
                !extra.containsKey('purpose')) {
              return const LoginPage();
            }

            return OtpPage(
              email: extra['email'] as String,
              purpose: extra['purpose'] as OtpPurpose,
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

            return ResetPasswordPage(email: extra['email'] as String);
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
