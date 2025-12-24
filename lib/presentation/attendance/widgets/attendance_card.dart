import 'package:flutter/material.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../config/theme/app_colors.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final isLate = attendance.status == AttendanceStatus.late;
    final isOnTime = attendance.status == AttendanceStatus.onTime;

    final hasTime =
        attendance.checkInTime != null || attendance.checkOutTime != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          // ===============================
          // DATE BOX
          // ===============================
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attendance.date.day.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text('/', style: TextStyle(fontSize: 12, height: 0.9)),
                Text(
                  attendance.date.month.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ===============================
          // STATUS & TIME
          // ===============================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(attendance.status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isLate
                        ? AppColors.danger
                        : isOnTime
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),

                if (hasTime) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (attendance.checkInTime != null) ...[
                        const Icon(
                          Icons.login,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          attendance.checkInTime!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                      if (attendance.checkInTime != null &&
                          attendance.checkOutTime != null)
                        const SizedBox(width: 12),
                      if (attendance.checkOutTime != null) ...[
                        const Icon(
                          Icons.logout,
                          size: 14,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          attendance.checkOutTime!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.onTime:
        return "On Time";
      case AttendanceStatus.late:
        return "Late";
      case AttendanceStatus.leave:
        return "Leave";
      case AttendanceStatus.holiday:
        return "Holiday";
    }
  }
}
