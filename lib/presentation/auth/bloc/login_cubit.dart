import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../core/services/device/local_storage_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;

  LoginCubit(this.authRepo) : super(const LoginState());

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

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
