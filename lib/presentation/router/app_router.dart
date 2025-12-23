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

// HOME & PROFILE
import '../home/bloc/home_cubit.dart';
import '../home/pages/home_page.dart';
import '../profile/pages/profile_page.dart';

// CALENDAR
import '../calendar/pages/calendar_page.dart';

// ✅ ATTENDANCE
import '../attendance/pages/attendance_page.dart';

// LEAVE APPROVAL (ADMIN / MANAGER)
import '../admin/pages/leave_approval_page.dart';
import '../admin/leave/bloc/leave_approval_cubit.dart';
import '../../domain/usecases/leave/get_pending_leaves.dart';
import '../../domain/usecases/leave/approve_leave.dart';
import '../../domain/usecases/leave/reject_leave.dart';

// LEAVE HISTORY (EMPLOYEE)
import '../leave/pages/leave_history_page.dart';
import '../leave/bloc/leave_cubit.dart';
import '../../domain/usecases/leave/get_leaves.dart';
import '../../domain/usecases/leave/create_leave.dart';

import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/login',

      // ===============================
      // AUTH & ROLE GUARD
      // ===============================
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;

        final isLogin = location == '/login';
        final isOtp = location == '/otp';
        final isResetPassword = location == '/reset-password';
        final isLeaveApproval = location == '/leave-approval';

        // ===============================
        // SUDAH LOGIN
        // ===============================
        if (authState is AuthAuthenticated) {
          if (isLogin || isOtp || isResetPassword) {
            return '/home';
          }

          // ROLE GUARD (Manager / HR)
          if (isLeaveApproval) {
            final role = authState.user['role'];
            if (role != 'Manager' && role != 'HR') {
              return '/home';
            }
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
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

        // ===============================
        // OTP
        // ===============================
        GoRoute(
          path: '/otp',
          builder: (context, state) {
            final authState = context.read<AuthCubit>().state;

            if (authState is! AuthOtpRequired) {
              return const LoginPage();
            }

            return BlocProvider(
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
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            if (extra == null || !extra.containsKey('email')) {
              return const LoginPage();
            }

            return BlocProvider(
              create: (context) =>
                  ResetPasswordCubit(context.read<ResetPassword>()),
              child: ResetPasswordPage(email: extra['email']),
            );
          },
        ),

        // ===============================
        // HOME (EMPLOYEE)
        // ===============================
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => HomeCubit()..loadDashboard(),
              child: const HomePage(),
            );
          },
        ),

        // ===============================
        // CALENDAR
        // ===============================
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarPage(),
        ),

        // ===============================
        // ✅ ATTENDANCE (EMPLOYEE)
        // ===============================
        GoRoute(
          path: '/attendance',
          builder: (context, state) => const AttendancePage(),
        ),

        // ===============================
        // PROFILE
        // ===============================
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),

        // ===============================
        // LEAVE HISTORY (EMPLOYEE)
        // ===============================
        GoRoute(
          path: '/leave',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => LeaveCubit(
                getLeaves: context.read<GetLeaves>(),
                createLeave: context.read<CreateLeave>(),
              )..fetchLeaves(),
              child: const LeaveHistoryPage(),
            );
          },
        ),

        // ===============================
        // LEAVE APPROVAL (MANAGER / HR)
        // ===============================
        GoRoute(
          path: '/leave-approval',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => LeaveApprovalCubit(
                getPendingLeaves: context.read<GetPendingLeaves>(),
                approveLeave: context.read<ApproveLeaveUsecase>(),
                rejectLeave: context.read<RejectLeaveUsecase>(),
              )..load(),
              child: const LeaveApprovalPage(),
            );
          },
        ),
      ],
    );
  }
}
