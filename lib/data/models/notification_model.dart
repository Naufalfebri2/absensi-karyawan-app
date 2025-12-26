import '../../domain/entities/notification_entity.dart';

/// ===============================
/// NOTIFICATION MODEL (DATA LAYER)
/// ===============================
///
/// - Representasi data dari API
/// - Tidak ada UI logic
/// - Mapping enum dilakukan di mapper (bukan di sini)
///
class NotificationModel {
  final int id;
  final String title;
  final String message;

  /// type dari API (string), contoh:
  /// "absensi", "meeting", "radius", dll
  final String type;

  /// status baca dari API
  final bool isRead;

  /// waktu dibuat (ISO string dari API)
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  /// ===============================
  /// FROM JSON
  /// ===============================
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// ===============================
  /// TO JSON
  /// ===============================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// ===============================
  /// TO ENTITY (OPTIONAL SHORTCUT)
  /// ===============================
  /// NOTE:
  /// Biasanya mapping dilakukan di NotificationMapper,
  /// method ini disediakan jika dibutuhkan cepat.
  NotificationEntity toEntity(NotificationType notificationType) {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: notificationType,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
