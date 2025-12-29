import 'package:dio/dio.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/attendance_action_entity.dart';

class AttendanceRemote {
  final Dio dio;

  AttendanceRemote(this.dio);

  // ===============================
  // ATTENDANCE HISTORY
  // ===============================
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,
  }) async {
    final response = await dio.get(
      '/attendance/daily',
      queryParameters: {'year': year, 'month': month},
      options: Options(headers: {'Accept': 'application/json'}),
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
  // TODAY ATTENDANCE
  // ===============================
  Future<AttendanceEntity?> getTodayAttendance() async {
    try {
      final response = await dio.get(
        '/attendance/history/',
        options: Options(headers: {'Accept': 'application/json'}),
      );
      print(response.data);
      final data = response.data['data'];
      if (data == null) return null;

      return AttendanceEntity.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      // 404 = belum ada presensi hari ini
      // print(e);
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  // ===============================
  // 🔥 SAVE CHECK IN (API BARU)
  // ===============================
  Future<AttendanceActionEntity> saveCheckIn({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
  }) async {
    final formData = FormData.fromMap({
      'time': _formatTime(time),
      'latitude': latitude,
      'longitude': longitude,
      'flag': 'check-in',
      'photo': await MultipartFile.fromFile(
        selfiePath,
        filename: selfiePath.split('/').last,
      ),
    });

    final response = await dio.post(
      '/attendance/presensi',
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return AttendanceActionEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }

  // ===============================
  // 🔥 SAVE CHECK OUT (API BARU)
  // ===============================
  Future<AttendanceEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
  }) async {
    final formData = FormData.fromMap({
      'time': _formatTime(time),
      'flag': 'check-out',
      'photo': await MultipartFile.fromFile(
        selfiePath,
        filename: selfiePath.split('/').last,
      ),
    });

    final response = await dio.post(
      '/attendance/presensi',
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return AttendanceEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }

  // ===============================
  // LEGACY (JANGAN DIHAPUS)
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
        'photoPath': photoPath,
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );

    return AttendanceEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }

  Future<AttendanceEntity> checkOut() async {
    final response = await dio.post(
      '/attendance/checkout',
      options: Options(headers: {'Accept': 'application/json'}),
    );

    return AttendanceEntity.fromJson(
      Map<String, dynamic>.from(response.data['data']),
    );
  }

  // ===============================
  // HELPER
  // ===============================
  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
