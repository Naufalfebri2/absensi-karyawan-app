import 'package:dio/dio.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/attendance_action_entity.dart';

class AttendanceRemote {
  final Dio dio;

  AttendanceRemote(this.dio);

  // ===============================
  // ATTENDANCE HISTORY (API FILTERED)
  // ===============================
  Future<List<AttendanceEntity>> getAttendanceHistory({
    required int year,
    required int month,

    // 🔥 NEW (API STATUS STRING)
    String? status,

    // 🔒 OPTIONAL
    int? employeeId,
  }) async {
    final response = await dio.get(
      '/attendance/daily',
      queryParameters: {
        'year': year,
        'month': month,
        if (status != null) 'status': status,
        if (employeeId != null) 'employee_id': employeeId,
      },
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
  // TODAY ATTENDANCE (FIXED)
  // ===============================
  Future<AttendanceEntity?> getTodayAttendance({int? employeeId}) async {
    try {
      final response = await dio.get(
        '/attendance/history/',
        queryParameters: {if (employeeId != null) 'employee_id': employeeId},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data['data'];

      // 🔹 Tidak ada data
      if (data == null) return null;

      // 🔹 API mengembalikan LIST
      if (data is List) {
        if (data.isEmpty) return null;

        return AttendanceEntity.fromJson(Map<String, dynamic>.from(data.first));
      }

      // 🔹 API mengembalikan OBJECT
      if (data is Map) {
        return AttendanceEntity.fromJson(Map<String, dynamic>.from(data));
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  // ===============================
  // SAVE CHECK IN
  // ===============================
  Future<AttendanceActionEntity> saveCheckIn({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
    int? employeeId,
  }) async {
    final formData = FormData.fromMap({
      'time': _formatTime(time),
      'latitude': latitude,
      'longitude': longitude,
      'flag': 'check-in',
      if (employeeId != null) 'employee_id': employeeId,
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
  // SAVE CHECK OUT
  // ===============================
  Future<AttendanceEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    int? employeeId,
  }) async {
    final formData = FormData.fromMap({
      'time': _formatTime(time),
      'flag': 'check-out',
      if (employeeId != null) 'employee_id': employeeId,
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
  // LEGACY SUPPORT (DO NOT REMOVE)
  // ===============================
  Future<AttendanceEntity> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final action = await saveCheckIn(
      time: DateTime.now(),
      status: AttendanceStatus.onTime,
      selfiePath: photoPath,
      latitude: latitude,
      longitude: longitude,
    );

    return AttendanceEntity(
      date: DateTime.now(),
      checkInTime: action.time,
      checkOutTime: null,
      status: AttendanceStatus.onTime,
    );
  }

  Future<AttendanceEntity> checkOut() async {
    return saveCheckOut(
      time: DateTime.now(),
      status: AttendanceStatus.earlyLeave,
      selfiePath: '',
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
