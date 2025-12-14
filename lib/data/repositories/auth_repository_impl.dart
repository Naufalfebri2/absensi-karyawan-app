import '../../domain/repositories/auth_repo.dart';
import '../datasources/remote/auth_remote.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemote remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) {
    return remote.login(username: username, password: password);
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp
  }) {
    return remote.verifyOtp(
      email: email,
      otp: otp
    );
  }
}
