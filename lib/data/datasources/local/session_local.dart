import 'dart:convert';
import '../../../core/services/device/local_storage_service.dart';
import '../../models/user_model.dart';

class SessionLocal {
  static const String _userKey = "user";
  static const String _roleKey = "role";

  static Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await LocalStorageService.write(_userKey, userJson);
    await saveUserRole(user.role);
  }

  static Future<UserModel?> getUser() async {
    final userJson = await LocalStorageService.read(_userKey);
    if (userJson == null) return null;
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  static Future<void> saveUserRole(String role) async {
    await LocalStorageService.write(_roleKey, role);
  }

  static Future<String?> getUserRole() async {
    return await LocalStorageService.read(_roleKey);
  }

  static Future<void> clearSession() async {
    await LocalStorageService.delete(_userKey);
    await clearUserRole();
  }

  static Future<void> clearUserRole() async {
    await LocalStorageService.delete(_roleKey);
  }
}
