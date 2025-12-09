import '../../core/services/device/local_storage_service.dart';

class AuthGuard {
  static Future<bool> isLoggedIn() async {
    final token = await LocalStorageService.getToken();
    return token != null && token.isNotEmpty;
  }
}
