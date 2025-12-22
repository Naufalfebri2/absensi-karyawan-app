import '../../domain/entities/leave_entity.dart';

class LeaveMapper {
  /// Convert API JSON → Domain Entity
  static LeaveEntity fromJson(Map<String, dynamic> json) {
    return LeaveEntity(
      id: json['leave_id'] ?? json['id'],
      employeeId: json['employee_id'],
      leaveType: json['leave_type'] ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      totalDays: _parseInt(json['total_days']),
      reason: json['reason'] ?? '',
      attachment: json['attachment'],
      status: json['status'] ?? 'pending',
      approvedBy: json['approved_by'],
      approvedDate: _parseDate(json['approved_date']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  /// Convert Domain Entity → JSON (jika suatu saat dibutuhkan)
  static Map<String, dynamic> toJson(LeaveEntity entity) {
    return {
      'leave_id': entity.id,
      'employee_id': entity.employeeId,
      'leave_type': entity.leaveType,
      'start_date': _formatDate(entity.startDate),
      'end_date': _formatDate(entity.endDate),
      'total_days': entity.totalDays,
      'reason': entity.reason,
      'attachment': entity.attachment,
      'status': entity.status,
      'approved_by': entity.approvedBy,
      'approved_date': _formatDate(entity.approvedDate),
      'created_at': _formatDate(entity.createdAt),
      'updated_at': _formatDate(entity.updatedAt),
    };
  }

  // ===============================
  // HELPER
  // ===============================

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(value.toString()) ?? 0;
  }

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;

    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
