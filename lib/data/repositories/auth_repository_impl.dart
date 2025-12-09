import '../../domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/remote/auth_remote.dart';
import '../datasources/local/session_local.dart';
import '../mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemote remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remote.login(email, password);
    await SessionLocal.saveUser(model);
    return UserMapper.toEntity(model);
  }

  @override
  Future<void> logout() async {
    await SessionLocal.clearSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await SessionLocal.getUser();
    return model != null ? UserMapper.toEntity(model) : null;
  }
}
