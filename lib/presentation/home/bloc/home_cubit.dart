import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/device/local_storage_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadUserData() async {
    emit(state.copyWith(isLoading: true));

    final name = await LocalStorageService.getFullName();
    final role = await LocalStorageService.getRole();
    final photo = await LocalStorageService.getPhotoUrl();

    emit(
      state.copyWith(
        isLoading: false,
        fullName: name,
        role: role,
        photoUrl: photo,
      ),
    );
  }
}
