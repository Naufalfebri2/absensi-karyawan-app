import 'package:flutter/material.dart';

import '../../../domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Material(
      color: isUnread
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(type: notification.type),
              const SizedBox(width: 12),
              Expanded(
                child: _Content(
                  title: notification.title,
                  message: notification.message,
                  createdAt: notification.createdAt,
                  isUnread: isUnread,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// ICON BADGE
/// ===============================
class _IconBadge extends StatelessWidget {
  final NotificationType type;

  const _IconBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final iconData = _mapIcon(type);
    final color = _mapColor(type);

    return CircleAvatar(
      radius: 22,
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(iconData, color: color, size: 22),
    );
  }

  IconData _mapIcon(NotificationType type) {
    switch (type) {
      case NotificationType.absensi:
        return Icons.access_time;
      case NotificationType.reminder:
        return Icons.warning_amber_rounded;
      case NotificationType.cuti:
        return Icons.description;
      case NotificationType.lembur:
        return Icons.timer;
      case NotificationType.meeting:
        return Icons.meeting_room;
      case NotificationType.dinas:
        return Icons.directions_car;
      case NotificationType.radius:
        return Icons.location_on;
      case NotificationType.checkOutTime:
        return Icons.logout;
      case NotificationType.overtimeStart:
        return Icons.nightlight_round;
    }
  }

  Color _mapColor(NotificationType type) {
    switch (type) {
      case NotificationType.absensi:
        return Colors.blue;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.cuti:
        return Colors.green;
      case NotificationType.lembur:
        return Colors.purple;
      case NotificationType.meeting:
        return Colors.teal;
      case NotificationType.dinas:
        return Colors.brown;
      case NotificationType.radius:
        return Colors.indigo;
      case NotificationType.checkOutTime:
        return Colors.red;
      case NotificationType.overtimeStart:
        return Colors.deepOrange;
    }
  }
}

/// ===============================
/// CONTENT
/// ===============================
class _Content extends StatelessWidget {
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isUnread;

  const _Content({
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Text(
          _formatTime(createdAt),
          style: textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
