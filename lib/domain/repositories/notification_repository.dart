import '../entities/notification_entity.dart';

/// ===============================
/// NOTIFICATION REPOSITORY
/// ===============================
///
/// Kontrak domain untuk fitur notifikasi
/// - Domain TIDAK tahu data source
/// - Domain TIDAK tahu Dio / API
/// - Error dilempar sebagai Failure (throw)
///
abstract class NotificationRepository {
  /// Ambil seluruh notifikasi user
  Future<List<NotificationEntity>> getNotifications();

  /// Tandai notifikasi sebagai sudah dibaca
  Future<void> markAsRead(int notificationId);
}
