import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestLocation() async {
    final result = await Permission.location.request();
    return result.isGranted;
  }

  static Future<bool> requestCamera() async {
    final result = await Permission.camera.request();
    return result.isGranted;
  }
}
