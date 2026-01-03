import '../../models/notification_model.dart';
import 'package:absensi_karyawan_app/core/services/notifications/notification_socket_service.dart';

/// ===============================
/// NOTIFICATION REMOTE DATASOURCE
/// ===============================
/// WebSocket-based (REALTIME)
/// NO REST / NO DIO
/// ===============================
abstract class NotificationRemoteDataSource {
  /// REALTIME notification stream
  Stream<NotificationModel> listen({required String token});

  /// Optional (backend event-based)
  Future<void> markAsRead(int notificationId);
}

/// ===============================
/// IMPLEMENTATION
/// ===============================
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NotificationSocketService socketService;

  NotificationRemoteDataSourceImpl({required this.socketService});

  @override
  Stream<NotificationModel> listen({required String token}) {
    return socketService
        .connect(token: token)
        .map((json) => NotificationModel.fromJson(json));
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    // 🔒 Backend sudah event-based via socket
    // Tidak perlu REST call
    return;
  }
}
