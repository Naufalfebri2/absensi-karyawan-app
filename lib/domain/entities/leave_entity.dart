class LeaveEntity {
  final int? id;
  final int? employeeId;

  // ===============================
  // ✅ TAMBAHAN UNTUK CALENDAR
  // ===============================
  final String employeeName;
  final String employeeAvatar;

  /// Jenis cuti (Cuti, Izin, Sakit, dll)
  final String leaveType;

  /// Tanggal mulai cuti
  final DateTime? startDate;

  /// Tanggal akhir cuti
  final DateTime? endDate;

  /// Total hari cuti
  final int totalDays;

  /// Alasan cuti
  final String reason;

  /// Path / URL file lampiran
  final String? attachment;

  /// Status: pending | approved | rejected
  final String status;

  /// Manager / HR yang menyetujui
  final int? approvedBy;

  /// Tanggal approval
  final DateTime? approvedDate;

  /// Timestamp pembuatan
  final DateTime? createdAt;

  /// Timestamp update terakhir
  final DateTime? updatedAt;

  const LeaveEntity({
    this.id,
    this.employeeId,

    // ✅ default aman (tidak merusak fitur lama)
    this.employeeName = '',
    this.employeeAvatar = '',

    required this.leaveType,
    this.startDate,
    this.endDate,
    required this.totalDays,
    required this.reason,
    this.attachment,
    required this.status,
    this.approvedBy,
    this.approvedDate,
    this.createdAt,
    this.updatedAt,
  });

  // ===============================
  // HELPER (DOMAIN-LEVEL LOGIC)
  // ===============================

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  int get durationInDays {
    if (startDate == null || endDate == null) return totalDays;
    return endDate!.difference(startDate!).inDays + 1;
  }

  bool get isPast {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }
}
