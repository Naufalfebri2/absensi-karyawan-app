import 'package:absensi_karyawan_app/domain/entities/user_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/auth_repo.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
