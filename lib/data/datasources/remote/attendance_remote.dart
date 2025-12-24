import 'package:dio/dio.dart';
import '../../../domain/entities/attendance_entity.dart';

class AttendanceRemote {
  final Dio dio;

  AttendanceRemote(this.dio);

  // ===============================
  // GET ATTENDANCE HISTORY
  // ===============================
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) async {
    final response = await dio.get(
      '/attendance',
      queryParameters: {'year': year, 'month': month},
      options: Options(
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer TOKEN', // jika belum pakai interceptor
        },
      ),
    );

    final data = response.data['data'];

    if (data == null || data is! List) return [];

    return data
        .map<AttendanceEntity>(
          (e) => AttendanceEntity.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  // ===============================
  // GET TODAY ATTENDANCE
  // ===============================
  Future<AttendanceEntity?> getTodayAttendance() async {
    final response = await dio.get(
      '/attendance/today',
      options: Options(
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer TOKEN',
        },
      ),
    );

    final data = response.data['data'];
    if (data == null) return null;

    return AttendanceEntity.fromJson(Map<String, dynamic>.from(data));
  }

  // ===============================
  // CHECK IN
  // ===============================
  Future<AttendanceEntity> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final response = await dio.post(
      '/attendance/checkin',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'PhotoPath': photoPath, // 🔥 HARUS SAMA DENGAN API
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer TOKEN',
        },
      ),
    );

    return AttendanceEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }

  // ===============================
  // CHECK OUT
  // ===============================
  Future<AttendanceEntity> checkOut() async {
    final response = await dio.post(
      '/attendance/checkout',
      options: Options(
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer TOKEN',
        },
      ),
    );

    return AttendanceEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }
}
