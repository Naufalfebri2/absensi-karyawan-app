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
    required String phoneNumber, // ✅ TAMBAH
    required String position,
    required String department,
  }) async {
    emit(ProfileLoading());

    try {
      final authState = authCubit.state;

      if (authState is! AuthAuthenticated) {
        emit(const ProfileError('Session tidak valid'));
        return;
      }

      final currentUser = authState.user;

      final updatedUser = await updateProfileUsecase(
        userId: currentUser.id,
        name: name,
        email: email,
        phoneNumber: phoneNumber, // ✅ KIRIM KE USECASE
        position: position,
        department: department,
      );

      // 🔥 UPDATE GLOBAL AUTH STATE
      await authCubit.setAuthenticated(
        token: authState.token,
        user: {
          'id': updatedUser.id,
          'name': updatedUser.name,
          'email': updatedUser.email,
          'phone_number': updatedUser.phoneNumber, // ✅ SIMPAN
          'position': updatedUser.position,
          'department': updatedUser.department,
          'avatar_url': currentUser.avatarUrl, // tetap
        },
      );

      emit(ProfileUpdateSuccess(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ===============================
  // UPDATE AVATAR (MULTIPART)
  // ===============================
  Future<void> updateAvatar(File image) async {
    // 🔥 OPTIMISTIC EMIT (avatar langsung berubah)
    emit(ProfileAvatarOptimistic(image));

    try {
      final authState = authCubit.state;

      if (authState is! AuthAuthenticated) {
        emit(const ProfileError('Session tidak valid'));
        return;
      }

      final currentUser = authState.user;

      // 🔥 CALL USECASE AVATAR
      final avatarUrl = await updateAvatarUsecase(
        userId: currentUser.id,
        image: image,
      );

      // 🔥 UPDATE GLOBAL AUTH STATE
      await authCubit.setAuthenticated(
        token: authState.token,
        user: {
          'id': currentUser.id,
          'name': currentUser.name,
          'email': currentUser.email,
          'phone_number': currentUser.phoneNumber, // ✅ TETAP
          'position': currentUser.position,
          'department': currentUser.department,
          'avatar_url': avatarUrl,
        },
      );

      // 🔥 FINAL CONFIRM STATE
      emit(ProfileLoaded(currentUser.copyWith(avatarUrl: avatarUrl)));
    } catch (e) {
      emit(ProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
