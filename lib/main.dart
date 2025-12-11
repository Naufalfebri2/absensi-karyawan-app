import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme
import 'config/theme/app_theme.dart';

// Router
import 'presentation/router/app_router.dart';

// Bloc
import 'package:absensi_karyawan_app/presentation/auth/bloc/login_cubit.dart';
import 'package:absensi_karyawan_app/presentation/auth/bloc/otp_cubit.dart';

// Usecases (dummy versi lokal)
import 'package:absensi_karyawan_app/domain/usecases/auth/login_user.dart';
import 'package:absensi_karyawan_app/domain/usecases/auth/otp_verify.dart';

// Repositories
import 'package:absensi_karyawan_app/data/repositories/auth_repository_impl.dart';
import 'package:absensi_karyawan_app/data/datasources/remote/auth_remote.dart';

// Dio client (tetap boleh dipakai)
import 'package:absensi_karyawan_app/core/network/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debugging interceptor (opsional)
  DioClient.addInterceptors();

  // Initialize dependencies
  final authRemote = AuthRemote(DioClient.instance);
  final authRepository = AuthRepositoryImpl(authRemote);

  runApp(AbsensiApp(authRepository: authRepository));
}

class AbsensiApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const AbsensiApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Login Cubit Provider
        BlocProvider(create: (_) => LoginCubit(LoginUser(authRepository))),

        /// OTP Cubit Provider
        BlocProvider(create: (_) => OtpCubit(OtpVerify(authRepository))),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Absensi Karyawan',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
