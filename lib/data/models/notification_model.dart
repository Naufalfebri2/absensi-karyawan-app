import '../../domain/entities/notification_entity.dart';

/// ===============================
/// NOTIFICATION MODEL (DATA LAYER)
/// ===============================
///
/// - Representasi data dari WebSocket payload
/// - Defensive parsing (anti crash)
/// - Tidak ada UI logic
/// - Mapping enum dilakukan di mapper
///
class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
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
  /// FROM JSON (DEFENSIVE)
  /// ===============================
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseInt(json['id']),
      title: _parseString(json['title']),
      message: _parseString(json['message']),
      type: _parseString(json['type']),
      isRead: _parseBool(json['is_read']),
      createdAt: _parseDate(json['created_at']),
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

  // =======================================================
  // DEFENSIVE PARSERS
  // =======================================================

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value is String) return value;
    return '';
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    if (value is int) {
      // unix timestamp (seconds or millis)
      return value > 1000000000000
          ? DateTime.fromMillisecondsSinceEpoch(value)
          : DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return DateTime.now();
  }
}
