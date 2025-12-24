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
    this.radiusMeter = 100,
  });

  /// ===================================================
  /// DEFAULT OFFICE LOCATION
  /// (Silakan sesuaikan koordinat kantor)
  /// ===================================================
  factory OfficeLocationEntity.defaultOffice() {
    return const OfficeLocationEntity(
      latitude: -6.343033, // 📍 Contoh: Universitas Pamulang
      longitude: 106.738285,
      radiusMeter: 100,
    );
  }

  /// ===================================================
  /// HELPER
  /// ===================================================

  /// Radius dalam kilometer
  double get radiusKm => radiusMeter / 1000;
}
