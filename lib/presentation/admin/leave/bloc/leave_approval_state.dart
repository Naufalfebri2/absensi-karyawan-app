abstract class LeaveApprovalState {}

class LeaveApprovalInitial extends LeaveApprovalState {}

class LeaveApprovalLoading extends LeaveApprovalState {}

class LeaveApprovalLoaded extends LeaveApprovalState {
  final List<dynamic> leaves;
  LeaveApprovalLoaded(this.leaves);
}

class LeaveApprovalError extends LeaveApprovalState {
  final String message;
  LeaveApprovalError(this.message);
}
