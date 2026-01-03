import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/errors/failures.dart';

import '../datasources/remote/notification_remote.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  /// In-memory cache (snapshot untuk domain)
  final List<NotificationEntity> _cache = [];

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      // Karena realtime via WebSocket,
      // repository hanya mengembalikan snapshot cache
      return List.unmodifiable(_cache);
    } catch (_) {
      throw const ServerFailure('Failed to load notifications');
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);

      final index = _cache.indexWhere((e) => e.id == notificationId);
      if (index != -1) {
        _cache[index] = _cache[index].copyWith(isRead: true);
      }
    } catch (_) {
      throw const ServerFailure('Failed to update notification');
    }
  }

  /// Dipanggil oleh Cubit saat socket event masuk
  void addToCache(NotificationEntity notification) {
    final exists = _cache.any((e) => e.id == notification.id);
    if (!exists) {
      _cache.insert(0, notification);
    }
  }
}
