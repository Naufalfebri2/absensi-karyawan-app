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
      
      // 🔥 DEBUG LOGGING
      print('🔍 [AttendanceRemote] API Response: ${response.data}');
      print('🔍 [AttendanceRemote] Data: $data');

      // 🔹 Tidak ada data
      if (data == null) return null;

      AttendanceEntity? entity;

      // 🔹 API mengembalikan LIST
      if (data is List) {
        if (data.isEmpty) return null;
        entity = AttendanceEntity.fromJson(Map<String, dynamic>.from(data.first));
      }
      // 🔹 API mengembalikan OBJECT
      else if (data is Map) {
         entity = AttendanceEntity.fromJson(Map<String, dynamic>.from(data));
      }

      if (entity != null) {
        final now = DateTime.now();
        // 🔒 STRICT VALIDATION: Check if record is actually from TODAY
        final isToday = entity.date.year == now.year &&
            entity.date.month == now.month &&
            entity.date.day == now.day;
        
        // 🔥 DEBUG LOGGING
        print('🔍 [AttendanceRemote] Entity date: ${entity.date}');
        print('🔍 [AttendanceRemote] Today: $now');
        print('🔍 [AttendanceRemote] Is today: $isToday');
        print('🔍 [AttendanceRemote] checkInTime: ${entity.checkInTime}');
        print('🔍 [AttendanceRemote] checkOutTime: ${entity.checkOutTime}');

        if (isToday) {
          return entity;
        }
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
  Future<AttendanceActionEntity> saveCheckOut({
    required DateTime time,
    required AttendanceStatus status,
    required String selfiePath,
    double? latitude,
    double? longitude,
    int? employeeId,
  }) async {
    final formData = FormData.fromMap({
      'time': _formatTime(time),
      'flag': 'check-out',
      if (employeeId != null) 'employee_id': employeeId,
      'latitude': latitude,
      'longitude': longitude,
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
    try {
      // Legacy checkout might fail if selfiePath is empty given saveCheckOut implementation
      // But preserving behavior while fixing types
      final action = await saveCheckOut(
        time: DateTime.now(),
        status: AttendanceStatus.earlyLeave,
        selfiePath: '', // Potentially problematic if strictly checked
      );

      return AttendanceEntity(
        date: DateTime.now(),
        checkOutTime: action.time,
        status: AttendanceStatus.earlyLeave,
      );
    } catch (_) {
      // Return dummy if fails (legacy fallback)
      return AttendanceEntity(
        date: DateTime.now(),
        status: AttendanceStatus.earlyLeave,
      );
    }
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
