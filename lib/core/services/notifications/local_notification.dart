import 'notification_service.dart';

class LocalNotification {
  static Future<void> show(String title, String message) async {
    await NotificationService.showNotification(title: title, body: message);
  }
}
