import 'dart:math';

class DistanceCalculator {
  static double calculate(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // distance in KM
  }

  static double _toRad(double deg) => deg * (pi / 180);
}
