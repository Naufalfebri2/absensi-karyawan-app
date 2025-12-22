import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadDashboard() async {
    // 🔥 Employee tidak perlu pending approval
    emit(HomeLoaded(pendingLeaveCount: 0));
  }
}
