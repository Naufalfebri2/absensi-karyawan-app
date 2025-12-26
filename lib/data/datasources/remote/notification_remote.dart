import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../models/notification_model.dart';

/// ===============================
/// NOTIFICATION REMOTE DATASOURCE
/// ===============================
abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(int notificationId);
}

/// ===============================
/// IMPLEMENTATION
/// ===============================
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final Response response = await DioClient.instance.get('/notifications');

      final data = response.data;

      if (data == null || data['data'] == null) {
        return [];
      }

      final List list = data['data'] as List;

      return list
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // ❗ JANGAN throw custom exception
      // Repository yang akan handle → Failure
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await DioClient.instance.post('/notifications/$notificationId/read');
    } catch (e) {
      rethrow;
    }
  }
}
