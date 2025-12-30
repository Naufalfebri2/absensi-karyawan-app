import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote.dart';
import '../mappers/user_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemote remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserEntity> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,

    // 🔥 PHONE NUMBER (STRING)
    String? phoneNumber,
  }) async {
    final response = await remote.updateProfile(
      userId: userId,
      name: name,
      email: email,
      position: position,
      department: department,

      // 🔥 PASS TO REMOTE (API NANTI)
      phoneNumber: phoneNumber,
    );

    return UserMapper.fromJson(response);
  }

  // ===============================
  // UPDATE LOGO / AVATAR
  // ===============================
  @override
  Future<String> updateLogo({required int userId, required File image}) async {
    final response = await remote.updateLogo(userId: userId, image: image);

    return response['avatar_url'] as String;
  }
}
