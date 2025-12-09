class LeaveModel {
  final int id;
  final int employeeId;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final String reason;
  final String status;
  final int? approvedBy;
  final DateTime? approvalDate;

  const LeaveModel({
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

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json["leave_id"] ?? json["id"],
      employeeId: json["employee_id"] ?? 0,
      type: json["leave_type"] ?? json["type"],
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"]),
      totalDays: json["total_days"]?.toDouble() ?? 0.0,
      reason: json["reason"] ?? "",
      status: json["status"],
      approvedBy: json["approved_by"],
      approvalDate: json["approval_date"] != null
          ? DateTime.parse(json["approval_date"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "leave_id": id,
      "employee_id": employeeId,
      "leave_type": type,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "total_days": totalDays,
      "reason": reason,
      "status": status,
      "approved_by": approvedBy,
      "approval_date": approvalDate?.toIso8601String(),
    };
  }
}
