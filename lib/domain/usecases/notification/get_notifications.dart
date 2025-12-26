import '../../entities/notification_entity.dart';
import '../../repositories/notification_repository.dart';

/// ===============================
/// GET NOTIFICATIONS USE CASE
/// ===============================
///
/// Tugas:
/// - Mengambil seluruh notifikasi user
/// - Tidak peduli sumber data (API / local)
/// - Tidak mengandung logic UI
///
class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  /// Ambil semua notifikasi
  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
}
