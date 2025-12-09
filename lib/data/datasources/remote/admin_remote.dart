import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../models/shift_model.dart';
import '../../models/user_model.dart';

class AdminRemote {
  final Dio dio;

  AdminRemote(this.dio);

  // GET ALL EMPLOYEES
  Future<List<UserModel>> getAllEmployees() async {
    final res = await dio.get(ApiEndpoints.adminUsers);
    return (res.data["data"] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  // GET ALL SHIFTS
  Future<List<ShiftModel>> getAllShifts() async {
    final res = await dio.get(ApiEndpoints.adminShifts);
    return (res.data["data"] as List)
        .map((e) => ShiftModel.fromJson(e))
        .toList();
  }

  // CREATE SHIFT
  Future<ShiftModel> createShift(ShiftModel shift) async {
    final res = await dio.post(
      ApiEndpoints.adminCreateShift,
      data: shift.toJson(),
    );
    return ShiftModel.fromJson(res.data["data"]);
  }

  // UPDATE SHIFT
  Future<ShiftModel> updateShift(ShiftModel shift) async {
    final res = await dio.put(
      "${ApiEndpoints.adminUpdateShift}/${shift.id}",
      data: shift.toJson(),
    );
    return ShiftModel.fromJson(res.data["data"]);
  }

  // DELETE SHIFT
  Future<void> deleteShift(int shiftId) async {
    await dio.delete("${ApiEndpoints.adminDeleteShift}/$shiftId");
  }
}
