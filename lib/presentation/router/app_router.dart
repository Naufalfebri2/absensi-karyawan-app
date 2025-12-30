import 'package:flutter/material.dart';
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
import '../home/bloc/home_state.dart';
import '../home/pages/home_page.dart';

import '../notifications/pages/notification_page.dart';

import '../calendar/pages/calendar_page.dart';

import '../attendance/pages/attendance_page.dart';
import '../attendance/pages/checkin_page.dart';
import '../attendance/pages/checkout_page.dart';
import '../attendance/bloc/attendance_cubit.dart';
import '../attendance/bloc/checkin_cubit.dart';
import '../attendance/bloc/checkout_cubit.dart';

import '../profile/pages/profile_page.dart';

import '../leave/pages/leave_history_page.dart';
import '../leave/bloc/leave_cubit.dart';

import '../admin/pages/leave_approval_page.dart';
import '../admin/leave/bloc/leave_approval_cubit.dart';

import '../../core/services/holiday/holiday_service.dart';
import '../../core/services/location/location_service.dart';

import '../../domain/usecases/attendance/get_today_attendance.dart';

import 'go_router_refresh_stream.dart';

class AppRouter {
  // ===============================
  // HELPER: CEK HARI LIBUR NASIONAL
  // ===============================
  static bool _isTodayHoliday(BuildContext context) {
    try {
      final homeCubit = context.read<HomeCubit?>();
      final state = homeCubit?.state;
      if (state is HomeLoaded) {
        return state.isHoliday;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ===============================
  // PREMIUM FADE + SLIDE TRANSITION
  // ===============================
  static CustomTransitionPage<T> _fadeSlide<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

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
        // ===============================
        // AUTH (NO TRANSITION)
        // ===============================
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

        // ===============================
        // TAB ROUTES (FADE + SLIDE)
        // ===============================
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              _fadeSlide(state: state, child: const HomePage()),
        ),

        GoRoute(
          path: '/calendar',
          pageBuilder: (context, state) =>
              _fadeSlide(state: state, child: const CalendarPage()),
        ),

        GoRoute(
          path: '/attendance',
          pageBuilder: (context, state) {
            return _fadeSlide(
              state: state,
              child: BlocProvider(
                create: (_) => AttendanceCubit(
                  repository: context.read(),
                  holidayService: context.read<HolidayService>(),
                )..init(),
                child: const AttendancePage(),
              ),
            );
          },
        ),

        GoRoute(
          path: '/leave',
          pageBuilder: (context, state) {
            final authState = context.read<AuthCubit>().state;

            if (authState is! AuthAuthenticated) {
              return _fadeSlide(state: state, child: const LoginPage());
            }

            return _fadeSlide(
              state: state,
              child: BlocProvider(
                create: (_) => LeaveCubit(
                  getLeaves: context.read(),
                  createLeave: context.read(),
                  user: authState.user, // ⬅️ INI KUNCI TERAKHIR
                )..fetchLeaves(),
                child: const LeaveHistoryPage(),
              ),
            );
          },
        ),

        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) {
            return _fadeSlide(state: state, child: const ProfilePage());
          },
        ),

        // ===============================
        // OTHER ROUTES (NO TRANSITION)
        // ===============================
        GoRoute(
          path: '/notifications',
          builder: (_, __) => const NotificationPage(),
        ),

        GoRoute(
          path: '/attendance/checkin',
          builder: (context, state) {
            if (_isTodayHoliday(context)) {
              return const HolidayBlockedPage();
            }

            return BlocProvider(
              create: (_) => CheckInCubit(
                locationService: context.read<LocationService>(),
                getTodayAttendance: context.read<GetTodayAttendance>(),
                attendanceRepository: context.read(),
              ),
              child: const CheckInPage(),
            );
          },
        ),

        GoRoute(
          path: '/attendance/checkout',
          builder: (context, state) {
            if (_isTodayHoliday(context)) {
              return const HolidayBlockedPage();
            }

            return BlocProvider(
              create: (_) => CheckOutCubit(
                locationService: context.read<LocationService>(),
                attendanceRepository: context.read(),
              ),
              child: const CheckOutPage(),
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
      ],
    );
  }
}

// ===============================
// BLOCKED PAGE (HARI LIBUR)
// ===============================
class HolidayBlockedPage extends StatelessWidget {
  const HolidayBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.event_busy, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Hari Libur Nasional',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Check In dan Check Out tidak dapat dilakukan pada tanggal merah.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
