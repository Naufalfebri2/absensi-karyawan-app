import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> verifyOtp(String otp);

  Future<void> logout();

  /// Mengambil user yang sedang login dari storage/session
  Future<UserEntity?> getCurrentUser();
}
