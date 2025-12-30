import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// ===============================
/// INITIAL
/// ===============================
class ProfileInitial extends ProfileState {}

/// ===============================
/// LOADING
/// ===============================
class ProfileLoading extends ProfileState {}

/// ===============================
/// LOADED (DATA USER)
/// ===============================
class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// ===============================
/// UPDATE SUCCESS
/// ===============================
class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// ===============================
/// ERROR
/// ===============================
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ===============================
/// OPTIMISTIC AVATAR
/// ===============================
class ProfileAvatarOptimistic extends ProfileState {
  final File avatarFile;

  const ProfileAvatarOptimistic(this.avatarFile);

  @override
  List<Object?> get props => [avatarFile];
}
