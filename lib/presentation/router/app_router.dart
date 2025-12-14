import 'package:go_router/go_router.dart';

import '../auth/pages/login_page.dart';
import '../auth/pages/otp_page.dart';
import '../home/pages/home_page.dart';
import '../profile/pages/profile_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
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

          return OtpPage(
            email: extra?['email'],
            // tempToken: extra?['temp_token'],
          );
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
