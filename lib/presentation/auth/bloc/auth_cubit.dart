import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../core/services/device/local_storage_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;

  AuthCubit(this.authRepo) : super(const AuthState());

  // AUTO LOGIN (SPLASH SCREEN)
  Future<void> loadSession() async {
    emit(state.copyWith(isLoading: true));

    final token = await LocalStorageService.getToken();
    final role = await LocalStorageService.getRole();
    final employeeId = await LocalStorageService.getEmployeeId();
    final fullName = await LocalStorageService.getFullName();
    final email = await LocalStorageService.getEmail();

    if (token != null) {
      emit(
        state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          role: role,
          employeeId: employeeId,
          fullName: fullName,
          email: email,
        ),
      );
    } else {
      emit(state.copyWith(isAuthenticated: false, isLoading: false));
    }
  }

  // LOGIN (EMAIL + PASSWORD)
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await authRepo.login(email: email, password: password);

      // Simpan session
      await LocalStorageService.saveToken(user.token);
      await LocalStorageService.saveRole(user.role);
      await LocalStorageService.saveEmployeeId(user.employeeId);
      await LocalStorageService.saveFullName(user.fullName);
      await LocalStorageService.saveEmail(user.email);

      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          role: user.role,
          employeeId: user.employeeId,
          fullName: user.fullName,
          email: user.email,
          userId: user.id,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // VERIFY OTP
  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await authRepo.verifyOtp(otp);

      await LocalStorageService.saveToken(user.token);

      emit(state.copyWith(isLoading: false, isAuthenticated: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await LocalStorageService.clearAll();

    emit(const AuthState(isAuthenticated: false));
  }
}
