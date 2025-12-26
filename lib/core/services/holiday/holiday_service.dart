import 'package:dio/dio.dart';

/// =======================================================
/// HOLIDAY SERVICE
/// INDONESIAN NATIONAL HOLIDAYS
/// =======================================================
/// Source API:
/// https://api-harilibur.vercel.app/api
///
/// Return format:
/// {
///   DateTime(2025, 1, 1)  : "Tahun Baru Masehi",
///   DateTime(2025, 3, 31) : "Hari Raya Idul Fitri 1446 H",
///   DateTime(2025, 12,25): "Hari Raya Natal",
/// }
/// =======================================================
class HolidayService {
  final Dio _dio;

  HolidayService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://api-harilibur.vercel.app',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        ),
      );

  /// ===================================================
  /// GET NATIONAL HOLIDAYS BY YEAR
  /// ===================================================
  Future<Map<DateTime, String>> getNationalHolidays(int year) async {
    try {
      final response = await _dio.get('/api');

      if (response.data is! List) {
        return {};
      }

      final Map<DateTime, String> holidays = {};

      for (final rawItem in response.data as List) {
        if (rawItem is! Map) continue;

        final item = Map<String, dynamic>.from(rawItem);

        if (item['is_national_holiday'] != true) continue;

        final rawDate = item['holiday_date'];
        final parsedDate = DateTime.tryParse(rawDate?.toString() ?? '');
        if (parsedDate == null || parsedDate.year != year) continue;

        final normalizedDate = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );

        final name =
            item['holiday_name'] ??
            item['holiday_name_local'] ??
            item['description'] ??
            'Libur Nasional';

        holidays[normalizedDate] = name.toString();
      }

      return holidays;
    } catch (e) {
      // Safe debug (tidak crash, tidak throw)
      // ignore: avoid_print
      print('[HolidayService] Error: $e');
      return {};
    }
  }
}
