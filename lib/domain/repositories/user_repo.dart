import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getProfile();

  Future<UserEntity> updateProfile(UserEntity user);

  /// Khusus HR/Admin untuk mengelola user
  Future<List<UserEntity>> getUsers();

  Future<UserEntity> createUser(UserEntity user);

  Future<UserEntity> updateUser(UserEntity user);

  Future<void> deleteUser(int userId);
}
