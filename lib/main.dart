import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';

// ===============================
// ROUTER
// ===============================
import 'presentation/router/app_router.dart';

// ===============================
// AUTH CUBIT
// ===============================
import 'presentation/auth/bloc/auth_cubit.dart';

// ===============================
// HOME CUBIT
// ===============================
import 'presentation/home/bloc/home_cubit.dart';

// ===============================
// NOTIFICATION CUBIT
// ===============================
import 'presentation/notifications/bloc/notification_cubit.dart';

// ===============================
// USECASES - AUTH
// ===============================
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/otp_verify.dart';
import 'domain/usecases/auth/reset_password.dart';

// ===============================
// USECASES - LEAVE
// ===============================
import 'domain/usecases/leave/get_leaves.dart';
import 'domain/usecases/leave/create_leave.dart';
import 'domain/usecases/leave/get_pending_leaves.dart';
import 'domain/usecases/leave/approve_leave.dart';
import 'domain/usecases/leave/reject_leave.dart';

// ===============================
// USECASES - ATTENDANCE
// ===============================
import 'domain/usecases/attendance/get_today_attendance.dart';

// ===============================
// USECASES - NOTIFICATION 🔥
// ===============================
import 'domain/usecases/notification/get_notifications.dart';
import 'domain/usecases/notification/mark_as_read.dart';

// ===============================
// DATA - AUTH
// ===============================
import 'data/repositories/auth_repository_impl.dart';
import 'data/datasources/remote/auth_remote.dart';

// ===============================
// DATA - LEAVE
// ===============================
import 'data/repositories/leave_repository_impl.dart';
import 'data/datasources/remote/leave_remote.dart';

// ===============================
// DATA - ATTENDANCE
// ===============================
import 'data/repositories/attendance_repository_impl.dart';
import 'data/datasources/remote/attendance_remote.dart';
import 'domain/repositories/attendance_repository.dart';

// ===============================
// DATA - NOTIFICATION 🔥
// ===============================
import 'data/datasources/remote/notification_remote.dart';
import 'data/repositories/notification_repository_impl.dart';

// ===============================
// CORE
// ===============================
import 'core/network/dio_client.dart';
import 'core/services/device/local_storage_service.dart';
import 'core/services/location/location_service.dart';

// ===============================
// HOLIDAY
// ===============================
import 'core/services/holiday/holiday_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===============================
  // CORE
  // ===============================
  final storage = LocalStorageService();

  DioClient.setupInterceptors(storage);
  final dio = DioClient.instance;

  // ===============================
  // AUTH
  // ===============================
  final authRemote = AuthRemote(dio);
  final authRepository = AuthRepositoryImpl(authRemote);

  // ===============================
  // LEAVE
  // ===============================
  final leaveRemote = LeaveRemote(dio);
  final leaveRepository = LeaveRepositoryImpl(leaveRemote);

  // ===============================
  // ATTENDANCE
  // ===============================
  final attendanceRemote = AttendanceRemote(dio);
  final attendanceRepository = AttendanceRepositoryImpl(
    remoteDataSource: attendanceRemote,
  );

  // ===============================
  // NOTIFICATION 🔥
  // ===============================
  final notificationRemote = NotificationRemoteDataSourceImpl();
  final notificationRepository = NotificationRepositoryImpl(
    remoteDataSource: notificationRemote,
  );

  final getNotifications = GetNotifications(notificationRepository);
  final markAsRead = MarkAsRead(notificationRepository);

  // ===============================
  // SERVICES
  // ===============================
  final holidayService = HolidayService();
  final locationService = LocationService();

  // ===============================
  // AUTH CUBIT
  // ===============================
  final authCubit = AuthCubit(storage);

  runApp(
    AbsensiApp(
      authRepository: authRepository,
      leaveRepository: leaveRepository,
      attendanceRepository: attendanceRepository,
      holidayService: holidayService,
      locationService: locationService,
      authCubit: authCubit,
      getNotifications: getNotifications,
      markAsRead: markAsRead,
    ),
  );
}

class AbsensiApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final LeaveRepositoryImpl leaveRepository;
  final AttendanceRepositoryImpl attendanceRepository;
  final HolidayService holidayService;
  final LocationService locationService;
  final AuthCubit authCubit;

  // 🔥 NOTIFICATION USECASES
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;

  const AbsensiApp({
    super.key,
    required this.authRepository,
    required this.leaveRepository,
    required this.attendanceRepository,
    required this.holidayService,
    required this.locationService,
    required this.authCubit,
    required this.getNotifications,
    required this.markAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ===============================
        // REPOSITORIES
        // ===============================
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<LeaveRepositoryImpl>.value(value: leaveRepository),
        RepositoryProvider<AttendanceRepository>.value(
          value: attendanceRepository,
        ),

        // ===============================
        // SERVICES
        // ===============================
        RepositoryProvider<HolidayService>.value(value: holidayService),
        RepositoryProvider<LocationService>.value(value: locationService),

        // ===============================
        // AUTH USECASES
        // ===============================
        RepositoryProvider<LoginUser>(create: (_) => LoginUser(authRepository)),
        RepositoryProvider<OtpVerify>(create: (_) => OtpVerify(authRepository)),
        RepositoryProvider<ResetPassword>(
          create: (_) => ResetPassword(authRepository),
        ),

        // ===============================
        // LEAVE USECASES
        // ===============================
        RepositoryProvider<GetLeaves>(
          create: (_) => GetLeaves(leaveRepository),
        ),
        RepositoryProvider<CreateLeave>(
          create: (_) => CreateLeave(leaveRepository),
        ),
        RepositoryProvider<GetPendingLeaves>(
          create: (_) => GetPendingLeaves(leaveRepository),
        ),
        RepositoryProvider<ApproveLeaveUsecase>(
          create: (_) => ApproveLeaveUsecase(leaveRepository),
        ),
        RepositoryProvider<RejectLeaveUsecase>(
          create: (_) => RejectLeaveUsecase(leaveRepository),
        ),

        // ===============================
        // ATTENDANCE USECASES
        // ===============================
        RepositoryProvider<GetTodayAttendance>(
          create: (_) => GetTodayAttendance(attendanceRepository),
        ),

        // ===============================
        // NOTIFICATION USECASES 🔥
        // ===============================
        RepositoryProvider<GetNotifications>.value(value: getNotifications),
        RepositoryProvider<MarkAsRead>.value(value: markAsRead),
      ],
      child: MultiBlocProvider(
        providers: [
          // ===============================
          // AUTH (GLOBAL)
          // ===============================
          BlocProvider<AuthCubit>.value(value: authCubit..checkAuthStatus()),

          // ===============================
          // HOME (GLOBAL)
          // ===============================
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              holidayService: holidayService,
              locationService: locationService,
              getTodayAttendance: context.read<GetTodayAttendance>(),
            )..loadDashboard(),
          ),

          // ===============================
          // NOTIFICATION (GLOBAL 🔔🔥)
          // ===============================
          BlocProvider<NotificationCubit>(
            create: (context) => NotificationCubit(
              getNotifications: context.read<GetNotifications>(),
              markAsRead: context.read<MarkAsRead>(),
            )..loadNotifications(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Absensi Karyawan',
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router(authCubit),
        ),
      ),
    );
  }
}
