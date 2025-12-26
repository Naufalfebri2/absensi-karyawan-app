import 'package:flutter/material.dart';

import '../../../domain/entities/attendance_entity.dart';
import '../../../config/theme/app_colors.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final hasTime = attendance.hasCheckIn || attendance.hasCheckOut;
    final statusColor = _statusColor(attendance.status);

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
                // STATUS LABEL
                Text(
                  _statusLabel(attendance.status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),

                // CHECK IN / OUT TIME
                if (hasTime) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (attendance.hasCheckIn) ...[
                        Icon(Icons.login, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          attendance.checkInTime!,
                          style: TextStyle(fontSize: 12, color: statusColor),
                        ),
                      ],
                      if (attendance.hasCheckIn && attendance.hasCheckOut)
                        const SizedBox(width: 12),
                      if (attendance.hasCheckOut) ...[
                        Icon(Icons.logout, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          attendance.checkOutTime!,
                          style: TextStyle(fontSize: 12, color: statusColor),
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

  // ===============================
  // STATUS LABEL
  // ===============================
  String _statusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.onTime:
        return 'On Time';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
      case AttendanceStatus.earlyLeave:
        return 'Early Leave';
      case AttendanceStatus.overtime:
        return 'Overtime';
    }
  }

  // ===============================
  // STATUS COLOR
  // ===============================
  Color _statusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.onTime:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.danger;
      case AttendanceStatus.leave:
        return AppColors.warning;
      case AttendanceStatus.holiday:
        return AppColors.textSecondary;
      case AttendanceStatus.earlyLeave:
        return Colors.deepOrange;
      case AttendanceStatus.overtime:
        return Colors.purple;
    }
  }
}
