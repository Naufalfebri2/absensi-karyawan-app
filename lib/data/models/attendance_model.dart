class AttendanceModel {
  final int id;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? latitude;
  final double? longitude;
  final String? photoIn;
  final String? photoOut;
  final String status;

  AttendanceModel({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    this.latitude,
    this.longitude,
    this.photoIn,
    this.photoOut,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json["log_id"],
      checkIn: json["check_in_time"] != null
          ? DateTime.parse(json["check_in_time"])
          : null,
      checkOut: json["check_out_time"] != null
          ? DateTime.parse(json["check_out_time"])
          : null,
      latitude: json["location_lat"]?.toDouble(),
      longitude: json["location_long"]?.toDouble(),
      photoIn: json["photo_check_in"],
      photoOut: json["photo_check_out"],
      status: json["status"],
    );
  }
}
