import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../../../config/api_endpoints.dart';

class AuthRemote {
  final Dio dio;

  AuthRemote(this.dio);

  Future<UserModel> login(String email, String password) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );

    return UserModel.fromJson(response.data["data"]);
  }

  Future<bool> verifyOtp(String code) async {
    final response = await dio.post(
      ApiEndpoints.verifyOtp,
      data: {"otp": code},
    );

    return response.data["success"] == true;
  }
}
