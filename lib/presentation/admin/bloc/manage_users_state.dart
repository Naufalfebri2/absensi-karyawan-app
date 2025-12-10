import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

class ManageUsersState extends Equatable {
  final bool isLoading;
  final List<UserEntity> users;
  final String? errorMessage;
  final bool success;

  const ManageUsersState({
    this.isLoading = false,
    this.users = const [],
    this.errorMessage,
    this.success = false,
  });

  ManageUsersState copyWith({
    bool? isLoading,
    List<UserEntity>? users,
    String? errorMessage,
    bool? success,
  }) {
    return ManageUsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isLoading, users, errorMessage, success];
}
