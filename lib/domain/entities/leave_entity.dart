class LeaveEntity {
  final int? id;
  final int? employeeId;

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

  /// Apakah cuti masih menunggu approval
  bool get isPending => status == 'pending';

  /// Apakah cuti sudah disetujui
  bool get isApproved => status == 'approved';

  /// Apakah cuti ditolak
  bool get isRejected => status == 'rejected';

  /// Lama cuti dalam hari (fallback dari date range)
  int get durationInDays {
    if (startDate == null || endDate == null) return totalDays;

    return endDate!.difference(startDate!).inDays + 1;
  }

  /// Apakah cuti sudah lewat
  bool get isPast {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }
}
