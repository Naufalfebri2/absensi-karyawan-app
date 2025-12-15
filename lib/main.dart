import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';

// Router
import 'presentation/router/app_router.dart';

// Cubit
import 'presentation/auth/bloc/login_cubit.dart';
import 'presentation/auth/bloc/otp_cubit.dart';
import 'presentation/auth/bloc/auth_cubit.dart';

// Usecases
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/otp_verify.dart';

// Repository & Remote
import 'data/repositories/auth_repository_impl.dart';
import 'data/datasources/remote/auth_remote.dart';

// Core
import 'core/network/dio_client.dart';
import 'core/services/device/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===============================
  // CORE DEPENDENCIES
  // ===============================
  final storage = LocalStorageService();

  // Setup Dio interceptor (token, logging)
  DioClient.setupInterceptors(storage);

  final dio = DioClient.instance;
  final authRemote = AuthRemote(dio);
  final authRepository = AuthRepositoryImpl(authRemote);

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
    return MultiBlocProvider(
      providers: [
        // ===============================
        // AUTH GLOBAL
        // ===============================
        BlocProvider.value(value: authCubit..checkAuthStatus()),

        // ===============================
        // LOGIN
        // ===============================
        BlocProvider(create: (_) => LoginCubit(LoginUser(authRepository))),

        // ===============================
        // OTP
        // ===============================
        BlocProvider(create: (_) => OtpCubit(OtpVerify(authRepository))),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Absensi Karyawan',
        theme: AppTheme.lightTheme,

        // 🔐 ROUTER GUARD AKTIF
        routerConfig: AppRouter.router(authCubit),
      ),
    );
  }
}
