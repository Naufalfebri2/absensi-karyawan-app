import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/bloc/auth_cubit.dart';
import '../auth/bloc/otp_cubit.dart';
import '../auth/bloc/otp_purpose.dart';
import '../auth/bloc/reset_password_cubit.dart';

import '../auth/pages/login_page.dart';
import '../auth/pages/otp_page.dart';
import '../auth/pages/reset_password_page.dart';

import '../../domain/usecases/auth/otp_verify.dart';
import '../../domain/usecases/auth/reset_password.dart';

import '../home/bloc/home_cubit.dart';
import '../home/pages/home_page.dart';

import '../calendar/pages/calendar_page.dart';

import '../attendance/pages/attendance_page.dart';
import '../attendance/bloc/attendance_cubit.dart';

import '../profile/pages/profile_page.dart';

import '../leave/pages/leave_history_page.dart';
import '../leave/bloc/leave_cubit.dart';

import '../admin/pages/leave_approval_page.dart';
import '../admin/leave/bloc/leave_approval_cubit.dart';

import '../../core/services/holiday/holiday_service.dart';

import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;

        final isLogin = location == '/login';
        final isOtp = location == '/otp';
        final isResetPassword = location == '/reset-password';

        if (authState is AuthAuthenticated) {
          if (isLogin || isOtp || isResetPassword) {
            return '/home';
          }
          return null;
        }

        if (authState is AuthOtpRequired) {
          if (isOtp) return null;
          return '/otp';
        }

        if (authState is AuthUnauthenticated || authState is AuthInitial) {
          if (isLogin || isResetPassword) return null;
          return '/login';
        }

        return null;
      },

      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

        GoRoute(
          path: '/otp',
          builder: (context, state) {
            final authState = context.read<AuthCubit>().state;

            if (authState is! AuthOtpRequired) {
              return const LoginPage();
            }

            return BlocProvider(
              create: (_) => OtpCubit(context.read<OtpVerify>()),
              child: OtpPage(email: authState.email, purpose: OtpPurpose.login),
            );
          },
        ),

        GoRoute(
          path: '/reset-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            if (extra == null || !extra.containsKey('email')) {
              return const LoginPage();
            }

            return BlocProvider(
              create: (_) => ResetPasswordCubit(context.read<ResetPassword>()),
              child: ResetPasswordPage(email: extra['email']),
            );
          },
        ),

        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => HomeCubit()..loadDashboard(),
              child: const HomePage(),
            );
          },
        ),

        GoRoute(path: '/calendar', builder: (_, __) => const CalendarPage()),

        GoRoute(
          path: '/attendance',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => AttendanceCubit(
                repository: context.read(),
                checkInUseCase: context.read(),
                holidayService: context.read<HolidayService>(),
              )..init(),
              child: const AttendancePage(),
            );
          },
        ),

        GoRoute(
          path: '/leave',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => LeaveCubit(
                getLeaves: context.read(),
                createLeave: context.read(),
              )..fetchLeaves(),
              child: const LeaveHistoryPage(),
            );
          },
        ),

        GoRoute(
          path: '/leave-approval',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => LeaveApprovalCubit(
                getPendingLeaves: context.read(),
                approveLeave: context.read(),
                rejectLeave: context.read(),
              )..load(),
              child: const LeaveApprovalPage(),
            );
          },
        ),

        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      ],
    );
  }
}
