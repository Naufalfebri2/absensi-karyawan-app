import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/department_entity.dart';
import '../../../domain/repositories/admin_repo.dart';
import 'manage_department_state.dart';

class ManageDepartmentCubit extends Cubit<ManageDepartmentState> {
  final AdminRepository adminRepo;

  ManageDepartmentCubit(this.adminRepo) : super(const ManageDepartmentState());

  Future<void> loadDepartments() async {
    emit(state.copyWith(isLoading: true));

    try {
      final list = await adminRepo.getAllDepartments();
      emit(state.copyWith(isLoading: false, departments: list));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createDepartment(DepartmentEntity department) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.createDepartment(department);
      await loadDepartments();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateDepartment(DepartmentEntity department) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.updateDepartment(department);
      await loadDepartments();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteDepartment(int id) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.deleteDepartment(id);
      await loadDepartments();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
