class NotificationEntity {
  final int id;
  final int employeeId;
  final String title;
  final String message;
  final String type; // Absensi, Izin, Cuti, Lembur, Reminder, dll
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    int? id,
    int? employeeId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
