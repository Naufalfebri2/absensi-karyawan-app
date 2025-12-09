import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// GENERIC WRITE
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// GENERIC READ
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// GENERIC DELETE
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// SPECIFIC TOKEN HANDLING (your original functions)
  static Future<void> saveToken(String token) async {
    await write("token", token);
  }

  static Future<String?> getToken() async {
    return await read("token");
  }

  static Future<void> clearToken() async {
    await delete("token");
  }
}
