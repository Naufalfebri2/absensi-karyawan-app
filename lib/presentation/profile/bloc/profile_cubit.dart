import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/profile/update_profile.dart';
import '../../../domain/usecases/profile/update_logo.dart';
import '../../auth/bloc/auth_cubit.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthCubit authCubit;
  final UpdateProfile updateProfileUsecase;
  final UpdateLogo updateAvatarUsecase;

  ProfileCubit({
    required this.authCubit,
    required this.updateProfileUsecase,
    required this.updateAvatarUsecase,
  }) : super(ProfileInitial());

  // ===============================
  // LOAD PROFILE (FROM AUTH STATE)
  // ===============================
  void loadProfile() {
    final authState = authCubit.state;

    if (authState is AuthAuthenticated) {
      emit(ProfileLoaded(authState.user));
    } else {
      emit(const ProfileError('User belum login'));
    }
  }

  // ===============================
  // UPDATE PROFILE (TEXT DATA)
  // ===============================
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String position,
    required String department,
    required String birthDate,
  }) async {
    emit(ProfileLoading());

    try {
      final authState = authCubit.state;

      if (authState is! AuthAuthenticated) {
        emit(const ProfileError('Session tidak valid'));
        return;
      }

      final currentUser = authState.user;

      // 🔹 Update ke backend
      await updateProfileUsecase(
        userId: currentUser.id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        position: position,
        department: department,
        birthDate: birthDate,
      );

      // 🔹 REFRESH SOURCE OF TRUTH DARI AUTH
      final refreshedUser = authCubit.state is AuthAuthenticated
          ? (authCubit.state as AuthAuthenticated).user
          : currentUser;

      // 🔹 UPDATE GLOBAL AUTH STATE
      await authCubit.setAuthenticated(
        token: authState.token,
        user: {
          'id': refreshedUser.id,
          'name': refreshedUser.name,
          'email': refreshedUser.email,
          'phone_number': refreshedUser.phoneNumber,
          'position': refreshedUser.position,
          'department': refreshedUser.department,
          'birth_date': refreshedUser.birthDate,
          'avatar_url': refreshedUser.avatarUrl,
        },
      );

      emit(ProfileUpdateSuccess(refreshedUser));
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ===============================
  // UPDATE AVATAR (MULTIPART)
  // ===============================
  Future<void> updateAvatar(File image) async {
    final authState = authCubit.state;

    if (authState is! AuthAuthenticated) {
      emit(const ProfileError('Session tidak valid'));
      return;
    }

    final currentUser = authState.user;
    final previousAvatar = currentUser.avatarUrl;

    // 🔥 OPTIMISTIC UI (PREVIEW DARI DEVICE)
    emit(ProfileAvatarOptimistic(image));

    try {
      // 🔹 Upload avatar ke backend
      final avatarUrl = await updateAvatarUsecase(
        userId: currentUser.id,
        image: image,
      );

      // 🔹 UPDATE GLOBAL AUTH STATE (SOURCE OF TRUTH)
      final updatedUser = currentUser.copyWith(avatarUrl: avatarUrl);

      await authCubit.setAuthenticated(
        token: authState.token,
        user: {
          'id': updatedUser.id,
          'name': updatedUser.name,
          'email': updatedUser.email,
          'phone_number': updatedUser.phoneNumber,
          'position': updatedUser.position,
          'department': updatedUser.department,
          'avatar_url': updatedUser.avatarUrl,
        },
      );

      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      // 🔥 ROLLBACK JIKA GAGAL
      emit(ProfileLoaded(currentUser.copyWith(avatarUrl: previousAvatar)));
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
