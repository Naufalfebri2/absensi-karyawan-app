import 'package:dio/dio.dart';
import '../../models/leave_model.dart';
import '../../../config/api_endpoints.dart';

class LeaveRemote {
  final Dio dio;
  LeaveRemote(this.dio);

  /// =========================================
  /// SUBMIT LEAVE
  /// =========================================
  Future<LeaveModel> submitLeave({
    required int employeeId,
    required String leaveType,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String? attachmentPath,
  }) async {
    final data = {
      "employee_id": employeeId,
      "leave_type": leaveType,
      "description": description,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
    };

    // Jika ada file lampiran
    FormData formData = FormData.fromMap({
      ...data,
      if (attachmentPath != null)
        "attachment": await MultipartFile.fromFile(attachmentPath),
    });

    final res = await dio.post(ApiEndpoints.leaveSubmit, data: formData);

    return LeaveModel.fromJson(res.data["data"]);
  }

  /// =========================================
  /// GET LEAVE HISTORY
  /// =========================================
  Future<List<LeaveModel>> getLeaveHistory({required int employeeId}) async {
    final res = await dio.get(
      ApiEndpoints.leaveHistory,
      queryParameters: {"employee_id": employeeId},
    );

    return (res.data["data"] as List)
        .map((e) => LeaveModel.fromJson(e))
        .toList();
  }

  /// =========================================
  /// APPROVE / REJECT LEAVE
  /// =========================================
  Future<LeaveModel> approveLeave({
    required int leaveId,
    required bool isApproved,
    String? note,
  }) async {
    final res = await dio.post(
      ApiEndpoints.leaveApprove,
      data: {"leave_id": leaveId, "is_approved": isApproved, "note": note},
    );

    return LeaveModel.fromJson(res.data["data"]);
  }
}
