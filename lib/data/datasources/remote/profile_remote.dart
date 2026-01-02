import 'dart:io';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';

class ProfileRemote {
  final Dio dio;

  ProfileRemote(this.dio);

  // ===============================
  // UPDATE PROFILE DATA
  // ===============================
  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String position,
    required String department,

    // 🔥 PHONE NUMBER (STRING)
    String? phoneNumber,
    String? birthDate,
  }) async {
    try {
      // ===============================
      // BUILD PAYLOAD (AMAN & DINAMIS)
      // ===============================
      final payload = <String, dynamic>{
        'user_id': userId,
        'name': name,
        'email': email,
        'position': position,
        'department': department,
      };

      // 🔥 KIRIM PHONE JIKA ADA
      if (phoneNumber != null) {
        payload['phone_number'] = phoneNumber;
      }
      
      // 🔥 KIRIM BIRTH DATE JIKA ADA
      if (birthDate != null) {
        payload['birth_date'] = birthDate;
      }

      final response = await dio.post(
        ApiEndpoint.profile,
        data: payload,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      return Map<String, dynamic>.from(response.data['data']);
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
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      if (data is Map && data['data'] is Map) {
        return Map<String, dynamic>.from(data['data']);
      }

      throw Exception('Format response avatar tidak valid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal upload logo');
    }
  }
}
