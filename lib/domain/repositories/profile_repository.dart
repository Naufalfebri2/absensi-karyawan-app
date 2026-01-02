import 'dart:io';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  // ===============================
  // UPDATE PROFILE DATA
  // ===============================
  Future<UserEntity> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,

    // 🔥 PHONE NUMBER (STRING)
    String? phoneNumber,
    String? birthDate,
  });

  // ===============================
  // UPDATE PROFILE LOGO / AVATAR
  // ===============================
  Future<String> updateLogo({required int userId, required File image});
}
