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
/// LOADING (GLOBAL PROFILE)
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
/// Dipakai jika ingin trigger UI feedback (snackbar / toast)
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
/// Avatar preview dari device, user data tetap dipegang UI
class ProfileAvatarOptimistic extends ProfileState {
  final File avatarFile;

  const ProfileAvatarOptimistic(this.avatarFile);

  @override
  List<Object?> get props => [avatarFile];
}

/// ===============================
/// AVATAR UPLOADING (OPTIONAL)
/// ===============================
/// Bisa dipakai jika UI ingin tampilkan progress khusus avatar
class ProfileAvatarUploading extends ProfileState {
  final UserEntity user;

  const ProfileAvatarUploading(this.user);

  @override
  List<Object?> get props => [user];
}
