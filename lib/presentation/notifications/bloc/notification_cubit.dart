import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/notification/get_notifications.dart';
import '../../../domain/usecases/notification/mark_as_read.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/device/local_storage_service.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/mappers/notification_mapper.dart';
import '../../../core/services/notifications/notification_socket_service.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final NotificationSocketService socketService;
  final LocalStorageService storage;

  StreamSubscription? _socketSubscription;
  bool _socketInitialized = false;

  NotificationCubit({
    required this.getNotifications,
    required this.markAsRead,
    required this.socketService,
    required this.storage,
  }) : super(const NotificationInitial());

  // ===============================
  // LOAD INITIAL NOTIFICATIONS (REST)
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

      // 🔥 Init socket once
      await _initSocket();
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
  // INIT SOCKET (ONCE)
  // ===============================
  Future<void> _initSocket() async {
    if (_socketInitialized) return;

    try {
      final token = await storage.getAccessToken();
      if (token == null) return;

      _socketSubscription = socketService
          .connect(token: token)
          .listen(_handleSocketMessage);

      _socketInitialized = true;
    } catch (_) {
      // silent fail (socket optional)
    }
  }

  // ===============================
  // HANDLE SOCKET MESSAGE (REALTIME)
  // ===============================
  void _handleSocketMessage(Map<String, dynamic> data) {
    try {
      final model = NotificationModel.fromJson(data);
      final entity = NotificationMapper.toEntity(model);

      final currentState = state;
      if (currentState is! NotificationLoaded) return;

      // Prevent duplicate
      final exists = currentState.notifications.any((e) => e.id == entity.id);
      if (exists) return;

      final updatedList = [entity, ...currentState.notifications];
      final unreadCount = updatedList.where((e) => !e.isRead).length;

      emit(
        NotificationLoaded(
          notifications: updatedList,
          unreadCount: unreadCount,
        ),
      );
    } catch (_) {
      // ignore malformed socket payload
    }
  }

  // ===============================
  // MARK AS READ (OPTIMISTIC)
  // ===============================
  Future<void> readNotification(NotificationEntity notification) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    try {
      await markAsRead(notification.id);

      final updatedList = currentState.notifications.map((e) {
        if (e.id == notification.id) {
          return e.copyWith(isRead: true);
        }
        return e;
      }).toList();

      final unreadCount = updatedList.where((e) => !e.isRead).length;

      emit(
        NotificationLoaded(
          notifications: updatedList,
          unreadCount: unreadCount,
        ),
      );
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
