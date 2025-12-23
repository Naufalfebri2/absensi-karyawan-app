import 'package:dio/dio.dart';

/// =======================================================
/// HOLIDAY SERVICE (INDONESIA NATIONAL HOLIDAYS)
/// =======================================================
class HolidayService {
  final Dio dio;

  HolidayService(this.dio);

  /// ===================================================
  /// GET ALL INDONESIAN NATIONAL HOLIDAYS (WITH NAME)
  /// ===================================================
  /// Return:
  /// {
  ///   DateTime(2025, 1, 1)  : "Tahun Baru Masehi",
  ///   DateTime(2025, 3, 31) : "Hari Raya Idul Fitri 1446 H",
  ///   DateTime(2025, 12,25) : "Hari Raya Natal",
  /// }
  Future<Map<DateTime, String>> getNationalHolidays(int year) async {
    final response = await dio.get('https://api-harilibur.vercel.app/api');

    final Map<DateTime, String> holidays = {};

    for (final item in response.data) {
      // hanya libur nasional resmi
      if (item['is_national_holiday'] == true) {
        final rawDate = item['holiday_date'];
        if (rawDate == null) continue;

        final date = DateTime.parse(rawDate);
        if (date.year != year) continue;

        final normalizedDate = DateTime(date.year, date.month, date.day);

        final name =
            item['holiday_name'] ??
            item['holiday_name_local'] ??
            item['description'] ??
            'Libur Nasional';

        holidays[normalizedDate] = name;
      }
    }

    return holidays;
  }
}
