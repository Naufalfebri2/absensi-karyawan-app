import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../models/user_model.dart';

class UserRemote {
  final Dio dio;

  UserRemote(this.dio);

  // GET PROFILE
  Future<UserModel> getProfile() async {
    final res = await dio.get(ApiEndpoints.userProfile);
    return UserModel.fromJson(res.data["data"]);
  }

  // UPDATE PROFILE
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final res = await dio.put(ApiEndpoints.userProfile, data: data);
    return UserModel.fromJson(res.data["data"]);
  }

  // HR / ADMIN FEATURES
  Future<List<UserModel>> getUsers() async {
    final res = await dio.get(ApiEndpoints.adminUsers);
    return (res.data["data"] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final res = await dio.post(ApiEndpoints.adminCreateUser, data: data);
    return UserModel.fromJson(res.data["data"]);
  }

  Future<UserModel> updateUser(Map<String, dynamic> data) async {
    final res = await dio.put(ApiEndpoints.adminUpdateUser, data: data);
    return UserModel.fromJson(res.data["data"]);
  }

  Future<void> deleteUser(int userId) async {
    await dio.delete("${ApiEndpoints.adminDeleteUser}/$userId");
  }
}
