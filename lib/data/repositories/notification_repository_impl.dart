import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/errors/failures.dart';

import '../datasources/remote/notification_remote.dart';
import '../mappers/notification_mapper.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final models = await remoteDataSource.getNotifications();
      return NotificationMapper.toEntityList(models);
    } catch (e) {
      throw const ServerFailure('Gagal memuat notifikasi');
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
    } catch (e) {
      throw const ServerFailure('Gagal memperbarui notifikasi');
    }
  }
}
