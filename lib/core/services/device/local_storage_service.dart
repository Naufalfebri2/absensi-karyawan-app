import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // GENERIC READ / WRITE / DELETE
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // ============================
  // TOKEN HANDLING
  // ============================
  static Future<void> saveToken(String token) async {
    await write("token", token);
  }

  static Future<String?> getToken() async {
    return await read("token");
  }

  static Future<void> clearToken() async {
    await delete("token");
  }

  // ============================
  // USER ROLE & EMPLOYEE INFO
  // ============================
  static Future<void> saveRole(String role) async {
    await write("role", role);
  }

  static Future<String?> getRole() async {
    return await read("role");
  }

  static Future<void> saveEmployeeId(int id) async {
    await write("employee_id", id.toString());
  }

  static Future<int?> getEmployeeId() async {
    final value = await read("employee_id");
    return value != null ? int.tryParse(value) : null;
  }

  // ============================
  // USER PROFILE (NAME / EMAIL / PHOTO)
  // ============================
  static Future<void> saveFullName(String name) async {
    await write("full_name", name);
  }

  static Future<String?> getFullName() async {
    return await read("full_name");
  }

  static Future<void> saveEmail(String email) async {
    await write("email", email);
  }

  static Future<String?> getEmail() async {
    return await read("email");
  }

  // ⭐ NEW: PHOTO PROFILE URL
  static Future<void> savePhotoUrl(String url) async {
    await write("photo_url", url);
  }

  static Future<String?> getPhotoUrl() async {
    return await read("photo_url");
  }

  // ============================
  // CLEAR ALL STORAGE (LOGOUT)
  // ============================
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
