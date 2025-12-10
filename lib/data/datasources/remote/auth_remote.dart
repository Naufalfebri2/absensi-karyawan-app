import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../../../config/api_endpoints.dart';

class AuthRemote {
  final Dio dio;

  AuthRemote(this.dio);

  // ==============================
  // LOGIN
  // ==============================
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );

    return UserModel.fromJson(response.data["data"]);
  }

  // ==============================
  // VERIFY OTP
  // ==============================
  Future<UserModel> verifyOtp(String otp) async {
    final response = await dio.post(ApiEndpoints.verifyOtp, data: {"otp": otp});

    return UserModel.fromJson(response.data["data"]);
  }

  // ==============================
  // GET PROFILE (optional)
  // ==============================
  Future<UserModel> getProfile() async {
    final response = await dio.get(ApiEndpoints.userProfile);
    return UserModel.fromJson(response.data["data"]);
  }
}
