import 'package:dio/dio.dart';

class HolidayService {
  final Dio dio;

  HolidayService(this.dio);

  Future<Set<DateTime>> getNationalHolidays(int year) async {
    final response = await dio.get('https://api-harilibur.vercel.app/api');

    final Set<DateTime> holidays = {};

    for (final item in response.data) {
      if (item['is_national_holiday'] == true) {
        final date = DateTime.parse(item['holiday_date']);
        if (date.year == year) {
          holidays.add(DateTime(date.year, date.month, date.day));
        }
      }
    }

    return holidays;
  }
}
