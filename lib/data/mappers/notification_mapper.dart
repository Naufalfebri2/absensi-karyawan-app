import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

/// ===============================
/// NOTIFICATION MAPPER
/// ===============================
///
/// Tugas:
/// - Mapping NotificationModel (data) → NotificationEntity (domain)
/// - Mapping string type dari API → NotificationType enum
/// - Menjaga domain layer tetap bersih dari string magic
///
class NotificationMapper {
  /// ===============================
  /// MAP MODEL TO ENTITY
  /// ===============================
  static NotificationEntity toEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      title: model.title,
      message: model.message,
      type: _mapType(model.type),
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }

  /// ===============================
  /// MAP LIST MODEL TO ENTITY
  /// ===============================
  static List<NotificationEntity> toEntityList(List<NotificationModel> models) {
    return models.map(toEntity).toList();
  }

  /// ===============================
  /// MAP STRING TYPE TO ENUM
  /// ===============================
  static NotificationType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'absensi':
        return NotificationType.absensi;

      case 'reminder':
        return NotificationType.reminder;

      case 'cuti':
        return NotificationType.cuti;

      case 'lembur':
        return NotificationType.lembur;

      case 'meeting':
        return NotificationType.meeting;

      case 'dinas':
        return NotificationType.dinas;

      case 'radius':
        return NotificationType.radius;

      case 'checkouttime':
      case 'check_out_time':
      case 'check-out-time':
        return NotificationType.checkOutTime;

      case 'overtimestart':
      case 'overtime_start':
      case 'overtime-start':
        return NotificationType.overtimeStart;

      default:
        // fallback paling aman
        return NotificationType.reminder;
    }
  }
}
