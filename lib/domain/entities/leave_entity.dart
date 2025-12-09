class LeaveEntity {
  final int id;
  final int employeeId;
  final String type; // Cuti, Izin, Sakit, Dinas, Lembur, dll
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final String reason;
  final String status; // Pending, Approved, Rejected
  final int? approvedBy;
  final DateTime? approvalDate;

  const LeaveEntity({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvalDate,
  });

  LeaveEntity copyWith({
    int? id,
    int? employeeId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    double? totalDays,
    String? reason,
    String? status,
    int? approvedBy,
    DateTime? approvalDate,
  }) {
    return LeaveEntity(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvalDate: approvalDate ?? this.approvalDate,
    );
  }
}
