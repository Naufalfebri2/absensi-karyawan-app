import 'package:dio/dio.dart';
import '../../models/attendance_model.dart';
import '../../../config/api_endpoints.dart';
import '../../../core/extensions/date_ext.dart';

class AttendanceRemote {
  final Dio dio;

  AttendanceRemote(this.dio);

  // CHECK IN
  Future<AttendanceModel> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final response = await dio.post(
      ApiEndpoints.checkIn,
      data: {
        "employee_id": employeeId,
        "latitude": latitude,
        "longitude": longitude,
        "photo_path": photoPath,
      },
    );

    return AttendanceModel.fromJson(response.data["data"]);
  }

  // CHECK OUT
  Future<AttendanceModel> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    final response = await dio.post(
      ApiEndpoints.checkOut,
      data: {
        "employee_id": employeeId,
        "latitude": latitude,
        "longitude": longitude,
        "photo_path": photoPath,
      },
    );

    return AttendanceModel.fromJson(response.data["data"]);
  }

  // HISTORY
  Future<List<AttendanceModel>> getHistory({
    required int employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{"employee_id": employeeId};
    if (startDate != null) {
      queryParameters["start_date"] = startDate.toShortDate();
    }
    if (endDate != null) {
      queryParameters["end_date"] = endDate.toShortDate();
    }

    final response = await dio.get(
      ApiEndpoints.attendanceHistory,
      queryParameters: queryParameters,
    );

    return (response.data["data"] as List)
        .map((e) => AttendanceModel.fromJson(e))
        .toList();
  }

  // OPTIONAL: detail per log id
  Future<AttendanceModel?> getDetail(int logId) async {
    final response = await dio.get("${ApiEndpoints.attendanceHistory}/$logId");

    if (response.data["data"] == null) return null;

    return AttendanceModel.fromJson(response.data["data"]);
  }
}
