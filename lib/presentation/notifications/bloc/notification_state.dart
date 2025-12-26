import 'package:equatable/equatable.dart';

import '../../../domain/entities/notification_entity.dart';

/// ===============================
/// NOTIFICATION STATE
/// ===============================

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// ===============================
/// INITIAL
/// ===============================
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// ===============================
/// LOADING
/// ===============================
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// ===============================
/// LOADED
/// ===============================
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// ===============================
/// ERROR
/// ===============================
class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
