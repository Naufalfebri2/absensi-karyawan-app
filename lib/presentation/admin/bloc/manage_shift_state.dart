import 'package:equatable/equatable.dart';
import '../../../domain/entities/shift_entity.dart';

class ManageShiftState extends Equatable {
  final bool isLoading;
  final List<ShiftEntity> shifts;
  final String? errorMessage;
  final bool success;

  const ManageShiftState({
    this.isLoading = false,
    this.shifts = const [],
    this.errorMessage,
    this.success = false,
  });

  ManageShiftState copyWith({
    bool? isLoading,
    List<ShiftEntity>? shifts,
    String? errorMessage,
    bool? success,
  }) {
    return ManageShiftState(
      isLoading: isLoading ?? this.isLoading,
      shifts: shifts ?? this.shifts,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isLoading, shifts, errorMessage, success];
}
