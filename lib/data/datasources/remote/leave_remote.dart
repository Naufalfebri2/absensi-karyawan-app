import 'dart:io';

import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';

class LeaveRemote {
  final Dio dio;

  LeaveRemote(this.dio);

  // ===============================
  // EMPLOYEE
  // ===============================

  /// GET leave milik user login
  Future<List<dynamic>> fetchLeaves() async {
    try {
      final response = await dio.get(
        ApiEndpoint.leaves,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;
      print(data);

      // ✅ Aman untuk berbagai bentuk response
      if (data is Map && data['data'] is List) {
        return List<dynamic>.from(data['data']);
      }

      if (data is List) {
        return List<dynamic>.from(data);
      }

      // fallback aman
      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal memuat data cuti');
    }
  }

  /// CREATE leave (pengajuan cuti / izin)
  Future<void> createLeave({
    required int employeeId, // ⬅️ DITAMBAHKAN
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required int totalDays,
    File? attachment,
  }) async {
    try {
      final formData = FormData.fromMap({
        'employee_id': employeeId, // ⬅️ WAJIB UNTUK BACKEND
        'leave_type': leaveType,
        'start_date': _formatDate(startDate),
        'end_date': _formatDate(endDate),
        'reason': reason,
        'total_days': totalDays,
        'status': 'pending',
        if (attachment != null)
          'attachment': await MultipartFile.fromFile(
            attachment.path,
            filename: attachment.path.split('/').last,
          ),
      });

      await dio.post(
        ApiEndpoint.leaves,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal mengajukan cuti');
    }
  }

  // ===============================
  // MANAGER / HR
  // ===============================

  /// GET leave yang masih pending (untuk approval)
  Future<List<dynamic>> fetchPendingLeaves() async {
    try {
      final response = await dio.get(
        ApiEndpoint.leavesPending,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = response.data;

      if (data is Map && data['data'] is List) {
        return List<dynamic>.from(data['data']);
      }

      if (data is List) {
        return List<dynamic>.from(data);
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Gagal memuat cuti pending',
      );
    }
  }

  /// APPROVE leave
  Future<void> approveLeave(int leaveId, String note) async {
    try {
      await dio.post(
        ApiEndpoint.approveLeave(leaveId),
        data: {'note': note, 'status': 'approved'},
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal menyetujui cuti');
    }
  }

  /// REJECT leave
  Future<void> rejectLeave(int leaveId, String note) async {
    try {
      await dio.post(
        ApiEndpoint.rejectLeave(leaveId),
        data: {'note': note, 'status': 'rejected'},
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal menolak cuti');
    }
  }

  // ===============================
  // HELPER
  // ===============================
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
