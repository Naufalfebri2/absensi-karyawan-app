import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/notification/get_notifications.dart';
import '../../../domain/usecases/notification/mark_as_read.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/device/local_storage_service.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/mappers/notification_mapper.dart';
import '../services/notification_socket_service.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final NotificationSocketService socketService;
  final LocalStorageService storage;

  StreamSubscription? _socketSubscription;

  NotificationCubit({
    required this.getNotifications,
    required this.markAsRead,
    required this.socketService,
    required this.storage,
  }) : super(const NotificationInitial());

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

      // 🔥 Connect WS if not connected
      _initSocket();
    } on Failure catch (e) {
      emit(NotificationError(message: e.message));
    } catch (_) {
      emit(
        const NotificationError(
          message: 'An error occurred while loading notifications',
        ),
      );
    }
  }

  // ===============================
  // INIT SOCKET
  // ===============================
  Future<void> _initSocket() async {
    try {
      final token = await storage.getAccessToken();
      if (token == null) return;

      if (!socketService.isConnected) {
        _socketSubscription?.cancel();
        _socketSubscription = socketService.connect(token: token).listen(
          (data) {
            _handleSocketMessage(data);
          },
        );
      }
    } catch (_) {
      // ignore
    }
  }

  void _handleSocketMessage(Map<String, dynamic> data) {
    if (state is NotificationLoaded) {
      try {
        final model = NotificationModel.fromJson(data);
        final entity = NotificationMapper.toEntity(model);

        final currentList = (state as NotificationLoaded).notifications;
        
        // Add to top
        final newList = [entity, ...currentList];
        final unreadCount = newList.where((e) => !e.isRead).length;

        emit(
          NotificationLoaded(
            notifications: newList,
            unreadCount: unreadCount,
          ),
        );
      } catch (_) {
        // ignore parse error
      }
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
          message: 'An error occurred while updating notifications',
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

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    socketService.disconnect();
    return super.close();
  }
}
