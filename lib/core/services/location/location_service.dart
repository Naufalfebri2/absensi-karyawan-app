import 'package:geolocator/geolocator.dart';

/// =======================================================
/// LOCATION SERVICE
/// =======================================================
/// - Handle permission lokasi
/// - Ambil posisi GPS user
/// - TIDAK mengandung UI
/// - Digunakan oleh HomeCubit
/// =======================================================
class LocationService {
  /// ===================================================
  /// CEK & MINTA PERMISSION
  /// ===================================================
  Future<void> _checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Layanan lokasi (GPS) tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Izin lokasi ditolak oleh pengguna');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Izin lokasi ditolak permanen. Silakan aktifkan dari pengaturan.',
      );
    }
  }

  /// ===================================================
  /// GET CURRENT POSITION (NEW API ✅)
  /// ===================================================
  Future<Position> getCurrentPosition() async {
    await _checkPermission();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  /// ===================================================
  /// GET LATITUDE & LONGITUDE SAJA
  /// ===================================================
  Future<LatLng> getLatLng() async {
    final position = await getCurrentPosition();

    return LatLng(latitude: position.latitude, longitude: position.longitude);
  }
}

/// =======================================================
/// SIMPLE LAT LNG MODEL
/// =======================================================
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({required this.latitude, required this.longitude});
}

/// =======================================================
/// LOCATION EXCEPTION
/// =======================================================
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => message;
}
