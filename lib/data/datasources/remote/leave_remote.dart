import 'package:dio/dio.dart';
import '../../models/leave_model.dart';
import '../../../config/api_endpoints.dart';

class LeaveRemote {
  final Dio dio;
  LeaveRemote(this.dio);

  Future<LeaveModel> submitLeave(Map<String, dynamic> data) async {
    final res = await dio.post(ApiEndpoints.leaveSubmit, data: data);
    return LeaveModel.fromJson(res.data["data"]);
  }

  Future<List<LeaveModel>> getLeaves() async {
    final res = await dio.get(ApiEndpoints.leaveList);
    return (res.data["data"] as List)
        .map((e) => LeaveModel.fromJson(e))
        .toList();
  }

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

  Future<List<LeaveModel>> getLeaveHistory(int employeeId) async {
    final res = await dio.get(
      "${ApiEndpoints.leaveHistory}?employee_id=$employeeId",
    );
    return (res.data["data"] as List)
        .map((e) => LeaveModel.fromJson(e))
        .toList();
  }
}
