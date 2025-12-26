import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/notification/get_notifications.dart';
import '../../../domain/usecases/notification/mark_as_read.dart';
import '../../../core/errors/failures.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;

  NotificationCubit({required this.getNotifications, required this.markAsRead})
    : super(const NotificationInitial());

  // ===============================
  // LOAD NOTIFICATIONS
  // ===============================
  Future<void> loadNotifications() async {
    emit(const NotificationLoading());

    try {
      final notifications = await getNotifications();

      final unreadCount = notifications.where((e) => !e.isRead).length;

      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } on Failure catch (e) {
      emit(NotificationError(message: e.message));
    } catch (_) {
      emit(
        const NotificationError(
          message: 'Terjadi kesalahan saat memuat notifikasi',
        ),
      );
    }
  }

  // ===============================
  // MARK AS READ
  // ===============================
  Future<void> readNotification(NotificationEntity notification) async {
    try {
      await markAsRead(notification.id);

      // Reload agar state konsisten dengan backend
      await loadNotifications();
    } on Failure catch (e) {
      emit(NotificationError(message: e.message));
    } catch (_) {
      emit(
        const NotificationError(
          message: 'Terjadi kesalahan saat memperbarui notifikasi',
        ),
      );
    }
  }

  // ===============================
  // REFRESH (OPTIONAL)
  // ===============================
  Future<void> refresh() async {
    await loadNotifications();
  }
}
