class ShiftModel {
  final int id;
  final String name;
  final String start;
  final String end;
  final int toleranceLate;

  ShiftModel({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.toleranceLate,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json["shift_id"],
      name: json["shift_name"],
      start: json["start_time"],
      end: json["end_time"],
      toleranceLate: json["tolerance_late"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "shift_id": id,
      "shift_name": name,
      "start_time": start,
      "end_time": end,
      "tolerance_late": toleranceLate,
    };
  }
}
