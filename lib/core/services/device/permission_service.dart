import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> locationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> cameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
}
