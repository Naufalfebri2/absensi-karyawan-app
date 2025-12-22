abstract class LeaveState {}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveLoaded extends LeaveState {
  final List<dynamic> leaves;
  LeaveLoaded(this.leaves);
}

class LeaveSuccess extends LeaveState {}

class LeaveError extends LeaveState {
  final String message;
  LeaveError(this.message);
}
