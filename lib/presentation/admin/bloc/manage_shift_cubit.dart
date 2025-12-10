import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/shift_entity.dart';
import '../../../domain/repositories/admin_repo.dart';
import 'manage_shift_state.dart';

class ManageShiftCubit extends Cubit<ManageShiftState> {
  final AdminRepository adminRepo;

  ManageShiftCubit(this.adminRepo) : super(const ManageShiftState());

  Future<void> loadShifts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final list = await adminRepo.getAllShifts();
      emit(state.copyWith(isLoading: false, shifts: list));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createShift(ShiftEntity shift) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.createShift(shift);
      await loadShifts();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> updateShift(ShiftEntity shift) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.updateShift(shift);
      await loadShifts();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteShift(int id) async {
    emit(state.copyWith(isLoading: true));

    try {
      await adminRepo.deleteShift(id);
      await loadShifts();
      emit(state.copyWith(success: true));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
