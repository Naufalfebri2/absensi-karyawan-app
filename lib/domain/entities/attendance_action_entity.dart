class AttendanceActionEntity {
  final int id;
  final String time; // HH:mm
  final String flag; // check-in / check-out
  final String photoPath;
  final String latitude;
  final String longitude;

  AttendanceActionEntity({
    required this.id,
    required this.time,
    required this.flag,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
  });

  factory AttendanceActionEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceActionEntity(
      id: json['id'],
      time: json['time'].toString(),
      flag: json['flag'].toString(),
      photoPath: json['photoPath'].toString(),
      latitude: (json['latitude']).toString(),
      longitude: (json['longitude']).toString(),
    );
  }
}
