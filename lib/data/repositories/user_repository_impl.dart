import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repo.dart';
import '../datasources/remote/user_remote.dart';
import '../mappers/user_mapper.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemote remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<UserEntity> getProfile() async {
    final model = await remote.getProfile();
    return UserMapper.toEntity(model);
  }

  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    final model = await remote.updateProfile(
      UserMapper.toModel(user).toJson(), // ✅ perbaikan
    );
    return UserMapper.toEntity(model);
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    final list = await remote.getUsers();
    return list.map((e) => UserMapper.toEntity(e)).toList();
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final model = await remote.createUser(
      UserMapper.toModel(user).toJson(), // ✅ perbaikan
    );
    return UserMapper.toEntity(model);
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final model = await remote.updateUser(
      UserMapper.toModel(user).toJson(), // ✅ perbaikan
    );
    return UserMapper.toEntity(model);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await remote.deleteUser(userId);
  }
}
