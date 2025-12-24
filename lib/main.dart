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
  // SERVICES (SINGLE INSTANCE)
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

  const AbsensiApp({
    super.key,
    required this.authRepository,
    required this.leaveRepository,
    required this.attendanceRepository,
    required this.holidayService,
    required this.locationService,
    required this.authCubit,
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
            create: (_) => HomeCubit(
              holidayService: holidayService,
              locationService: locationService,
            )..loadDashboard(),
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
