class AttendanceModel {
  final int id;
  final int? employeeId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? latitude;
  final double? longitude;
  final String? photoIn;
  final String? photoOut;
  final String status;
  final double? totalWorkHours;

  AttendanceModel({
    required this.id,
    this.employeeId,
    required this.checkIn,
    required this.checkOut,
    this.latitude,
    this.longitude,
    this.photoIn,
    this.photoOut,
    required this.status,
    this.totalWorkHours,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json["log_id"] ?? json["id"],
      employeeId: json["employee_id"],
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
      status: json["status"] ?? "-",
      totalWorkHours: json["total_work_hours"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "log_id": id,
      "employee_id": employeeId,
      "check_in_time": checkIn?.toIso8601String(),
      "check_out_time": checkOut?.toIso8601String(),
      "location_lat": latitude,
      "location_long": longitude,
      "photo_check_in": photoIn,
      "photo_check_out": photoOut,
      "status": status,
      "total_work_hours": totalWorkHours,
    };
  }
}
