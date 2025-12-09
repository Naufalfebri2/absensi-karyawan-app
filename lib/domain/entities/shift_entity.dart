class ShiftEntity {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final int toleranceLate;

  const ShiftEntity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.toleranceLate,
  });

  ShiftEntity copyWith({
    int? id,
    String? name,
    String? startTime,
    String? endTime,
    int? toleranceLate,
  }) {
    return ShiftEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      toleranceLate: toleranceLate ?? this.toleranceLate,
    );
  }
}
