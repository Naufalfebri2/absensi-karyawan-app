import 'package:geolocator/geolocator.dart';

class GpsService {
  static Future<bool> isEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
