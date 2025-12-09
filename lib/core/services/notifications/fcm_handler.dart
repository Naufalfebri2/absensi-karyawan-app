import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHandler {
  static final _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _fcm.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      print("FCM Received: ${message.notification?.title}");
    });
  }

  static Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
