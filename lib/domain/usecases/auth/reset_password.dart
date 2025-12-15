import '../../repositories/auth_repo.dart';

class ResetPassword {
  final AuthRepo repo;

  ResetPassword(this.repo);

  Future<Map<String, dynamic>> call({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return repo.resetPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
