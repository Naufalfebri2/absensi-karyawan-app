import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class HolidayHelper {
  static final Dio _dio = Dio();

  /// Semua libur nasional + cuti bersama
  static final Map<DateTime, String> _holidays = {};

  static bool _loaded = false;

  // ===============================
  // LOAD API (sekali saja)
  // ===============================
  static Future<void> load() async {
    if (_loaded) return;

    try {
      final response = await _dio.get('https://api-harilibur.vercel.app/api');

      for (final item in response.data) {
        final date = DateFormat('yyyy-MM-dd').parse(item['holiday_date']);

        final name = item['holiday_name'] as String;

        _holidays[DateTime(date.year, date.month, date.day)] = name;
      }

      _loaded = true;
    } catch (e) {
      // fallback aman (tidak crash)
      _loaded = true;
    }
  }

  // ===============================
  // CHECKERS
  // ===============================
  static bool isHoliday(DateTime day) {
    return _holidays.containsKey(_normalize(day));
  }

  static String? getLabel(DateTime day) {
    return _holidays[_normalize(day)];
  }

  static bool isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  static DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
