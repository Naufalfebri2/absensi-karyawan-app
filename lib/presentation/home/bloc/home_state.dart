abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int pendingLeaveCount;

  HomeLoaded({required this.pendingLeaveCount});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
