import 'package:dio/dio.dart';
import '../../models/shift_model.dart';
import '../../../config/api_endpoints.dart';

class ShiftRemote {
  final Dio dio;

  ShiftRemote(this.dio);

  Future<List<ShiftModel>> getShifts() async {
    final res = await dio.get(ApiEndpoints.shiftList);
    return (res.data["data"] as List)
        .map((e) => ShiftModel.fromJson(e))
        .toList();
  }

  Future<ShiftModel> updateShift(ShiftModel model) async {
    final res = await dio.put(
      "${ApiEndpoints.adminUpdateShift}/${model.id}",
      data: model.toJson(),
    );
    return ShiftModel.fromJson(res.data["data"]);
  }
}
