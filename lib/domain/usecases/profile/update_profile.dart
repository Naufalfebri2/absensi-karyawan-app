import '../../entities/user_entity.dart';
import '../../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  /// ===============================
  /// EXECUTE UPDATE PROFILE
  /// ===============================
  Future<UserEntity> call({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,

    // 🔥 PHONE NUMBER (STRING)
    String? phoneNumber,
    String? birthDate,
  }) async {
    // ===============================
    // VALIDASI BUSINESS LOGIC
    // ===============================
    if (name.trim().isEmpty) {
      throw Exception('Nama tidak boleh kosong');
    }

    if (email.trim().isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    if (phoneNumber != null && phoneNumber.trim().isEmpty) {
      throw Exception('Phone number tidak boleh kosong');
    }

    // ===============================
    // CALL REPOSITORY
    // ===============================
    final updatedUser = await repository.updateProfile(
      userId: userId,
      name: name,
      email: email,
      position: position,
      department: department,

      // 🔥 PHONE NUMBER (NANTI API PAKAI)
      phoneNumber: phoneNumber,
      birthDate: birthDate,
    );

    return updatedUser;
  }
}
