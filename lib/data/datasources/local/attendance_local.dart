import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceLocal {
  static const String _pendingKey = "pending_attendance";

  static Future<void> savePendingAttendance(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(_pendingKey) ?? [];
    saved.add(jsonEncode(data));
    await prefs.setStringList(_pendingKey, saved);
  }

  static Future<List<Map<String, dynamic>>> getPendingAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_pendingKey) ?? [];
    return saved.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clearPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingKey);
  }
}
