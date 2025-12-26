import 'dart:async';

import '../../../domain/entities/notification_entity.dart';

/// ===============================
/// NOTIFICATION SERVICE
/// ===============================
///
/// Tugas:
/// - Trigger notifikasi berbasis kondisi (radius & waktu)
/// - Menjaga agar notifikasi tidak spam
/// - Fokus MVP: app aktif (foreground)
///
/// NOTE:
/// - Tidak ada UI
/// - Tidak ada API
/// - Bisa di-extend ke FCM / background task
///
class NotificationService {
  // ===============================
  // INTERNAL STATE (ANTI SPAM)
  // ===============================
  bool _radiusNotified = false;
  bool _checkOutTimeNotified = false;
  bool _overtimeNotified = false;

  Timer? _timer;

  /// ===============================
  /// START TIME WATCHER
  /// ===============================
  /// Dipanggil sekali (misalnya di HomeCubit init)
  void startTimeWatcher({
    required bool hasCheckedIn,
    required bool hasCheckedOut,
    required void Function(NotificationEntity) onNotify,
  }) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();

      // ===============================
      // JAM PULANG (17.00)
      // ===============================
      if (hasCheckedIn &&
          !hasCheckedOut &&
          now.hour == 17 &&
          !_checkOutTimeNotified) {
        _checkOutTimeNotified = true;

        onNotify(
          _buildNotification(
            type: NotificationType.checkOutTime,
            title: 'Jam Pulang',
            message: 'Sudah memasuki jam pulang, silakan check-out',
          ),
        );
      }

      // ===============================
      // JAM LEMBUR (21.00)
      // ===============================
      if (hasCheckedIn &&
          !hasCheckedOut &&
          now.hour == 21 &&
          !_overtimeNotified) {
        _overtimeNotified = true;

        onNotify(
          _buildNotification(
            type: NotificationType.overtimeStart,
            title: 'Jam Lembur',
            message: 'Anda memasuki batas jam lembur (21.00)',
          ),
        );
      }
    });
  }

  /// ===============================
  /// CHECK RADIUS (GPS)
  /// ===============================
  void checkRadius({
    required double distance,
    required double officeRadius,
    required bool hasCheckedIn,
    required void Function(NotificationEntity) onNotify,
  }) {
    if (distance <= officeRadius && !hasCheckedIn && !_radiusNotified) {
      _radiusNotified = true;

      onNotify(
        _buildNotification(
          type: NotificationType.radius,
          title: 'Area Kantor',
          message: 'Anda sudah berada di area kantor, silakan check-in',
        ),
      );
    }
  }

  /// ===============================
  /// RESET (HARUS DIPANGGIL)
  /// ===============================
  /// Dipanggil saat:
  /// - hari berganti
  /// - logout
  /// - session reset
  void reset() {
    _radiusNotified = false;
    _checkOutTimeNotified = false;
    _overtimeNotified = false;
    _timer?.cancel();
    _timer = null;
  }

  /// ===============================
  /// BUILD NOTIFICATION ENTITY
  /// ===============================
  NotificationEntity _buildNotification({
    required NotificationType type,
    required String title,
    required String message,
  }) {
    return NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      message: message,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
    );
  }
}
