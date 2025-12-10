import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/admin_repo.dart';
import '../../../domain/repositories/user_repo.dart';
import 'manage_users_state.dart';

class ManageUsersCubit extends Cubit<ManageUsersState> {
  final AdminRepository adminRepo;
  final UserRepository userRepo;

  ManageUsersCubit(this.adminRepo, this.userRepo)
    : super(const ManageUsersState());

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true));

    try {
      final list = await adminRepo.getAllEmployees();
      emit(state.copyWith(isLoading: false, users: list));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createUser(UserEntity user) async {
    emit(state.copyWith(isLoading: true));

    try {
      await userRepo.createUser(user);
      await loadUsers();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateUser(UserEntity user) async {
    emit(state.copyWith(isLoading: true));

    try {
      await userRepo.updateUser(user);
      await loadUsers();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteUser(int id) async {
    emit(state.copyWith(isLoading: true));

    try {
      await userRepo.deleteUser(id);
      await loadUsers();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
