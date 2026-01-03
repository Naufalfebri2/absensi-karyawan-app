import 'dart:io';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';

class ProfileRemote {
  final Dio dio;

  ProfileRemote(this.dio);

  // ===============================
  // UPDATE PROFILE DATA
  // ===============================
  Future<void> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,
    String? phoneNumber,
    String? birthDate,
  }) async {
    try {
      final payload = <String, dynamic>{
        'user_id': userId,
        'name': name,
        'email': email,
        'position': position,
        'department': department,
      };

      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        payload['phone_number'] = phoneNumber;
      }

      if (birthDate != null && birthDate.isNotEmpty) {
        payload['birth_date'] = birthDate;
      }

      final response = await dio.post(
        ApiEndpoint.profile,
        data: payload,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      // 🔥 VALIDASI RESPONSE
      if (data is Map && data['status'] == true) {
        return;
      }

      throw Exception(data['message'] ?? 'Gagal update profile');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal update profile');
    }
  }

  // ===============================
  // UPDATE PROFILE LOGO / AVATAR
  // ===============================
  Future<Map<String, dynamic>> updateLogo({
    required int userId,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'avatar': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '${ApiEndpoint.profile}/avatar',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final data = response.data;

      if (data is Map && data['status'] == true && data['data'] is Map) {
        return Map<String, dynamic>.from(data['data']);
      }

      throw Exception(data['message'] ?? 'Gagal upload avatar');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal upload avatar');
    }
  }

  // ===============================
  // GET PROFILE (SOURCE OF TRUTH)
  // ===============================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get(
        ApiEndpoint.profile,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      if (data is Map && data['status'] == true && data['data'] is Map) {
        return Map<String, dynamic>.from(data['data']);
      }

      throw Exception(data['message'] ?? 'Gagal mengambil data profile');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Gagal mengambil data profile',
      );
    }
  }
}
