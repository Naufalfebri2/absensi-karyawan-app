import 'package:dio/dio.dart';
import '../../models/attendance_model.dart';
import '../../../config/api_endpoints.dart';
import '../../../core/extensions/date_ext.dart';

class AttendanceRemote {
  final Dio dio;

  AttendanceRemote(this.dio);

  // ======================================================
  // CHECK IN
  // ======================================================
  Future<AttendanceModel> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.checkIn,
        data: {
          "employee_id": employeeId,
          "latitude": latitude,
          "longitude": longitude,
          "photo_path": photoPath,
        },
      );

      return AttendanceModel.fromJson(res.data["data"]);
    } catch (e) {
      throw Exception("Check-in gagal: $e");
    }
  }

  // ======================================================
  // CHECK OUT
  // ======================================================
  Future<AttendanceModel> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.checkOut,
        data: {
          "employee_id": employeeId,
          "latitude": latitude,
          "longitude": longitude,
          "photo_path": photoPath,
        },
      );

      return AttendanceModel.fromJson(res.data["data"]);
    } catch (e) {
      throw Exception("Check-out gagal: $e");
    }
  }

  // ======================================================
  // GET TODAY ATTENDANCE
  // ======================================================
  Future<AttendanceModel?> getTodayAttendance({required int employeeId}) async {
    try {
      final res = await dio.get(
        ApiEndpoints.todayAttendance,
        queryParameters: {"employee_id": employeeId},
      );

      if (res.data["data"] == null) return null;

      return AttendanceModel.fromJson(res.data["data"]);
    } catch (e) {
      throw Exception("Gagal memuat absensi hari ini: $e");
    }
  }

  // ======================================================
  // GET HISTORY
  // ======================================================
  Future<List<AttendanceModel>> getHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = {
      "employee_id": employeeId,
      if (startDate != null) "start_date": startDate.toShortDate(),
      if (endDate != null) "end_date": endDate.toShortDate(),
    };

    try {
      final res = await dio.get(
        ApiEndpoints.attendanceHistory,
        queryParameters: queryParams,
      );

      return (res.data["data"] as List)
          .map((e) => AttendanceModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Gagal memuat history absensi: $e");
    }
  }

  // ======================================================
  // DETAIL LOG (Optional)
  // ======================================================
  Future<AttendanceModel?> getDetail(int logId) async {
    try {
      final res = await dio.get("${ApiEndpoints.attendanceHistory}/$logId");

      if (res.data["data"] == null) return null;

      return AttendanceModel.fromJson(res.data["data"]);
    } catch (e) {
      throw Exception("Gagal memuat detail absensi: $e");
    }
  }
}
