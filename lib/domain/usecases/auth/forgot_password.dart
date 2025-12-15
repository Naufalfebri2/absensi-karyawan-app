import '../../repositories/auth_repo.dart';

class ForgotPassword {
  final AuthRepo repository;

  ForgotPassword(this.repository);

  Future<Map<String, dynamic>> call({required String email}) async {
    return await repository.forgotPassword(email: email);
  }
}
