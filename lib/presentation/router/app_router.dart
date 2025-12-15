import 'package:go_router/go_router.dart';

import '../auth/bloc/auth_cubit.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/otp_page.dart';
import '../home/pages/home_page.dart';
import '../profile/pages/profile_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/login',

      // 🔐 ROUTER GUARD
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;

        final isLogin = location == '/login';
        final isOtp = location == '/otp';

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
          if (!isLogin && !isOtp) {
            return '/login';
          }
          return null;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),

        GoRoute(
          path: '/otp',
          name: 'otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            // 🛡️ PROTEKSI OTP
            if (extra == null || !extra.containsKey('email')) {
              return const LoginPage();
            }

            return OtpPage(email: extra['email']);
          },
        ),

        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    );
  }
}
