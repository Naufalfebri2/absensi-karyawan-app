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

  /// apakah sudah dibaca
  final bool isRead;

  /// waktu notifikasi dibuat
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, message, type, isRead, createdAt];
}
