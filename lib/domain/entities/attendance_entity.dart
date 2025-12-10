class AttendanceEntity {
  final int id;
  final int? employeeId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? latitude;
  final double? longitude;
  final String? photoIn;
  final String? photoOut;
  final String status; // Hadir, Terlambat, PulangCepat, Lembur, Alfa, dll
  final double? totalWorkHours;

  /// Tambahan: tanggal absensi (diambil dari checkIn jika ada)
  DateTime get date => checkIn ?? checkOut ?? DateTime.now();

  const AttendanceEntity({
    required this.id,
    this.employeeId,
    this.checkIn,
    this.checkOut,
    this.latitude,
    this.longitude,
    this.photoIn,
    this.photoOut,
    required this.status,
    this.totalWorkHours,
  });

  AttendanceEntity copyWith({
    int? id,
    int? employeeId,
    DateTime? checkIn,
    DateTime? checkOut,
    double? latitude,
    double? longitude,
    String? photoIn,
    String? photoOut,
    String? status,
    double? totalWorkHours,
  }) {
    return AttendanceEntity(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoIn: photoIn ?? this.photoIn,
      photoOut: photoOut ?? this.photoOut,
      status: status ?? this.status,
      totalWorkHours: totalWorkHours ?? this.totalWorkHours,
    );
  }

  // ================================
  //  CUSTOM GETTERS UNTUK UI
  // ================================

  /// Format tanggal Baku: "12 Jan 2024"
  String get dateString {
    final d = date;
    return "${d.day.toString().padLeft(2, '0')} "
        "${_month(d.month)} "
        "${d.year}";
  }

  /// Jam check-in → "08:23"
  String get checkInTime {
    if (checkIn == null) return "-";
    return "${checkIn!.hour.toString().padLeft(2, '0')}:${checkIn!.minute.toString().padLeft(2, '0')}";
  }

  /// Jam check-out → "17:10"
  String get checkOutTime {
    if (checkOut == null) return "-";
    return "${checkOut!.hour.toString().padLeft(2, '0')}:${checkOut!.minute.toString().padLeft(2, '0')}";
  }

  /// Helper nama bulan
  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    return months[m - 1];
  }
}
