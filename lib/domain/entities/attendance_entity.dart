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
}
