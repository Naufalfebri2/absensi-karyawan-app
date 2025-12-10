import 'package:equatable/equatable.dart';
import '../../../domain/entities/department_entity.dart';

class ManageDepartmentState extends Equatable {
  final bool isLoading;
  final List<DepartmentEntity> departments;
  final String? errorMessage;
  final bool success;

  const ManageDepartmentState({
    this.isLoading = false,
    this.departments = const [],
    this.errorMessage,
    this.success = false,
  });

  ManageDepartmentState copyWith({
    bool? isLoading,
    List<DepartmentEntity>? departments,
    String? errorMessage,
    bool? success,
  }) {
    return ManageDepartmentState(
      isLoading: isLoading ?? this.isLoading,
      departments: departments ?? this.departments,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isLoading, departments, errorMessage, success];
}
