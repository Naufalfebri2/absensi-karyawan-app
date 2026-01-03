import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote.dart';
import '../mappers/user_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemote remote;

  ProfileRepositoryImpl(this.remote);

  // ===============================
  // UPDATE PROFILE (TEXT DATA)
  // ===============================
  @override
  Future<UserEntity> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,
    String? phoneNumber,
    String? birthDate,
  }) async {
    // 🔥 API HANYA UPDATE, TIDAK RETURN USER
    await remote.updateProfile(
      userId: userId,
      name: name,
      email: email,
      position: position,
      department: department,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
    );

    // 🔥 SOURCE OF TRUTH = GET PROFILE
    final profileResponse = await remote.getProfile();

    return UserMapper.fromJson(profileResponse);
  }

  // ===============================
  // UPDATE LOGO / AVATAR
  // ===============================
  @override
  Future<String> updateLogo({required int userId, required File image}) async {
    final response = await remote.updateLogo(userId: userId, image: image);

    // 🔥 HANDLE RESPONSE DENGAN AMAN
    if (response['data'] != null && response['data']['photo_profile'] != null) {
      return response['data']['photo_profile'] as String;
    }

    throw Exception('Gagal memperbarui avatar');
  }
}
