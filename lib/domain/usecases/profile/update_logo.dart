import 'dart:io';

import '../../repositories/profile_repository.dart';

class UpdateLogo {
  final ProfileRepository repository;

  UpdateLogo(this.repository);

  /// ===============================
  /// UPDATE PROFILE LOGO / AVATAR
  /// ===============================
  Future<String> call({required int userId, required File image}) async {
    if (!image.existsSync()) {
      throw Exception('File gambar tidak valid');
    }

    final avatarUrl = await repository.updateLogo(userId: userId, image: image);

    return avatarUrl;
  }
}
