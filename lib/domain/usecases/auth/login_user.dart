import '../../repositories/auth_repo.dart';

class LoginUser {
  final AuthRepo repo;

  LoginUser(this.repo);

  Future<Map<String, dynamic>> call({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading

    // Dummy login
    if (username == "admin" && password == "admin123") {
      return {'success': true, 'user_id': 1, 'temp_token': 'TEMP-12345'};
    }

    return {'success': false, 'message': "Username atau password salah"};
  }
}
