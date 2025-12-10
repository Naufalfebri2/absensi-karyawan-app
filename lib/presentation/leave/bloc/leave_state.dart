part of 'leave_cubit.dart';

class LeaveState {
  final bool isLoading; // Loading saat fetch history
  final bool isSubmitting; // Loading saat submit
  final bool isSuccess; // Submit berhasil

  final List<LeaveEntity> leaves;
  final LeaveEntity? newLeave;

  final String? error;

  const LeaveState({
    required this.isLoading,
    required this.isSubmitting,
    required this.isSuccess,
    required this.leaves,
    this.newLeave,
    this.error,
  });

  factory LeaveState.initial() => LeaveState(
    isLoading: false,
    isSubmitting: false,
    isSuccess: false,
    leaves: [],
    newLeave: null,
    error: null,
  );

  LeaveState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isSuccess,
    List<LeaveEntity>? leaves,
    LeaveEntity? newLeave,
    String? error,
  }) {
    return LeaveState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      leaves: leaves ?? this.leaves,
      newLeave: newLeave ?? this.newLeave,
      error: error,
    );
  }
}
