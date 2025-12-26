import '../../repositories/notification_repository.dart';

/// ===============================
/// MARK NOTIFICATION AS READ
/// ===============================
///
/// Tugas:
/// - Menandai notifikasi sebagai sudah dibaca
/// - Dipanggil saat user tap notifikasi
/// - Tidak mengandung UI / API logic
///
class MarkAsRead {
  final NotificationRepository repository;

  MarkAsRead(this.repository);

  /// Tandai notifikasi sebagai sudah dibaca
  ///
  /// [notificationId] = id notifikasi
  Future<void> call(int notificationId) async {
    await repository.markAsRead(notificationId);
  }
}
