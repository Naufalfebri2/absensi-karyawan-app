// =======================================================
// OFFICE LOCATION ENTITY
// =======================================================
// Representasi lokasi kantor & radius absensi
// Digunakan untuk validasi Check-In / Check-Out
// =======================================================

class OfficeLocationEntity {
  /// Latitude kantor
  final double latitude;

  /// Longitude kantor
  final double longitude;

  /// Radius absensi dalam meter
  /// Default: 100 meter
  final double radiusMeter;

  const OfficeLocationEntity({
    required this.latitude,
    required this.longitude,
    this.radiusMeter = 300,
  });

  /// ===================================================
  /// DEFAULT OFFICE LOCATION
  /// (Silakan sesuaikan koordinat kantor)
  /// ===================================================
  factory OfficeLocationEntity.defaultOffice() {
    return const OfficeLocationEntity(
      latitude: -6.3441667, // 📍 Contoh: Universitas Pamulang
      longitude: 106.737155,
      radiusMeter: 300,
    );
  }

  /// ===================================================
  /// HELPER
  /// ===================================================

  /// Radius dalam kilometer
  double get radiusKm => radiusMeter / 1000;
}
