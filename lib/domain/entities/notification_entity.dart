import 'package:equatable/equatable.dart';

/// ===============================
/// NOTIFICATION TYPE ENUM
/// ===============================
enum NotificationType {
  absensi, // Check-in, check-out, belum absen
  reminder, // Reminder absensi
  cuti, // Cuti disetujui / ditolak
  lembur, // Lembur disetujui
  meeting, // Jadwal meeting
  dinas, // Dinas luar kantor
  radius, // Masuk radius kantor
  checkOutTime, // Jam pulang (17.00)
  overtimeStart, // Batas jam lembur (21.00)
}

/// ===============================
/// NOTIFICATION ENTITY
/// ===============================
class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  /// ===============================
  /// COPY WITH (IMMUTABLE UPDATE)
  /// ===============================
  NotificationEntity copyWith({
    int? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, isRead, createdAt];
}
