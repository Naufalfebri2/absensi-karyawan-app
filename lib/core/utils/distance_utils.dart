import 'dart:math';

/// =======================================================
/// DISTANCE UTILS
/// =======================================================
/// Utility untuk menghitung jarak dua koordinat GPS
/// Menggunakan rumus Haversine
/// - Akurat untuk jarak pendek (meter)
/// - Pure function (mudah dites)
/// =======================================================

class DistanceUtils {
  static const double _earthRadiusKm = 6371.0;

  /// ===================================================
  /// HITUNG JARAK DALAM METER
  /// ===================================================
  static double distanceInMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceKm = _earthRadiusKm * c;

    return distanceKm * 1000; // meter
  }

  /// ===================================================
  /// CEK APAKAH DALAM RADIUS
  /// ===================================================
  static bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double officeLat,
    required double officeLon,
    required double radiusMeter,
  }) {
    final distance = distanceInMeters(
      lat1: userLat,
      lon1: userLon,
      lat2: officeLat,
      lon2: officeLon,
    );

    return distance <= radiusMeter;
  }

  /// ===================================================
  /// FORMAT JARAK (UNTUK UI)
  /// ===================================================
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
