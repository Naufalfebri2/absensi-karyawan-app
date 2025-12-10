import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
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
    // Call API
    final model = await remote.login(email: email, password: password);

    // Save session
    await SessionLocal.saveUser(model);

    return UserMapper.toEntity(model);
  }

  @override
  Future<UserEntity> verifyOtp(String otp) async {
    // API returns UserModel
    final model = await remote.verifyOtp(otp);

    // Save updated session
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
    if (model == null) return null;

    return UserMapper.toEntity(model);
  }
}
