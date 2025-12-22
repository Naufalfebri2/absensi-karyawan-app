import 'package:intl/intl.dart';

/// Helper untuk cek apakah suatu tanggal termasuk libur nasional
class HolidayUtils {
  /// Format internal: yyyy-MM-dd
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  /// Cek apakah [date] termasuk hari libur
  static bool isHoliday(DateTime date, List<Map<String, String>> holidays) {
    final formattedDate = _formatter.format(date);

    return holidays.any((h) => h['date'] == formattedDate);
  }

  /// Ambil nama libur (jika ada)
  static String? getHolidayName(
    DateTime date,
    List<Map<String, String>> holidays,
  ) {
    final formattedDate = _formatter.format(date);

    final match = holidays.firstWhere(
      (h) => h['date'] == formattedDate,
      orElse: () => {},
    );

    return match['name'];
  }
}
