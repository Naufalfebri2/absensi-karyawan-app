import 'package:dio/dio.dart';
import '../../models/notification_model.dart';
import '../../../config/api_endpoints.dart';

class NotificationRemote {
  final Dio dio;

  NotificationRemote(this.dio);

  Future<List<NotificationModel>> getNotifications() async {
    final res = await dio.get(ApiEndpoints.notificationList);
    return (res.data["data"] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }
}
