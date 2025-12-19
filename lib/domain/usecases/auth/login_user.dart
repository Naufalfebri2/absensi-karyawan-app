import '../../repositories/auth_repo.dart';
import 'package:dio/dio.dart';

class LoginUser {
  final AuthRepo repo;

  LoginUser(this.repo);

  Future<Map<String, dynamic>> call({
    required String username,
    required String password,
  }) async {
    try {
      final response = await repo.loginUser(
        username: username,
        password: password,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        return Map<String, dynamic>.from(e.response!.data);
      }

      return {'success': false, 'message': 'Gagal terhubung ke server'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan tak terduga'};
    }
  }
}
