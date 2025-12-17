import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';

// ===============================
// ROUTER
// ===============================
import 'presentation/router/app_router.dart';

// ===============================
// CUBIT (GLOBAL)
// ===============================
import 'presentation/auth/bloc/auth_cubit.dart';

// ===============================
// USE CASES
// ===============================
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/otp_verify.dart';
import 'domain/usecases/auth/reset_password.dart';

// ===============================
// DATA LAYER
// ===============================
import 'data/repositories/auth_repository_impl.dart';
import 'data/datasources/remote/auth_remote.dart';

// ===============================
// CORE
// ===============================
import 'core/network/dio_client.dart';
import 'core/services/device/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===============================
  // CORE SERVICES
  // ===============================
  final storage = LocalStorageService();

  // Setup Dio interceptor (token, logging)
  DioClient.setupInterceptors(storage);

  final dio = DioClient.instance;
  final authRemote = AuthRemote(dio);
  final authRepository = AuthRepositoryImpl(authRemote);

  // 🔐 AUTH CUBIT (SATU-SATUNYA)
  final authCubit = AuthCubit(storage);

  runApp(AbsensiApp(authRepository: authRepository, authCubit: authCubit));
}

class AbsensiApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final AuthCubit authCubit;

  const AbsensiApp({
    super.key,
    required this.authRepository,
    required this.authCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ===============================
        // REPOSITORY
        // ===============================
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),

        // ===============================
        // USE CASES
        // ===============================
        RepositoryProvider<LoginUser>(create: (_) => LoginUser(authRepository)),
        RepositoryProvider<OtpVerify>(create: (_) => OtpVerify(authRepository)),
        RepositoryProvider<ResetPassword>(
          create: (_) => ResetPassword(authRepository),
        ),
      ],
      child: BlocProvider<AuthCubit>.value(
        // ✅ HANYA AUTH CUBIT GLOBAL
        value: authCubit..checkAuthStatus(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Absensi Karyawan',
          theme: AppTheme.lightTheme,

          // ===============================
          // ROUTER (AUTH GUARD AKTIF)
          // ===============================
          routerConfig: AppRouter.router(authCubit),
        ),
      ),
    );
  }
}
