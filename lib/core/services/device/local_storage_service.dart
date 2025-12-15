import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyUser = 'auth_user';

  /// ===============================
  /// ACCESS TOKEN
  /// ===============================
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// ===============================
  /// USER DATA
  /// ===============================
  Future<void> saveUser(dynamic user) async {
    final prefs = await SharedPreferences.getInstance();

    // user diasumsikan Map / JSON
    final String userJson = jsonEncode(user);
    await prefs.setString(_keyUser, userJson);
  }

  Future<dynamic> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_keyUser);

    if (userJson == null) return null;

    return jsonDecode(userJson);
  }

  /// ===============================
  /// CLEAR ALL SESSION
  /// ===============================
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyUser);
  }
}
