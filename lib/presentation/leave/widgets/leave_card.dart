import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final String leaveType;
  final String startDate;
  final String endDate;
  final int totalDays;
  final String status;

  const LeaveCard({
    super.key,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = DateFormat('yyyy-MM-dd').parse(startDate);
    final end = DateFormat('yyyy-MM-dd').parse(endDate);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leaveType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // DATE RANGE
            Text(
              '${DateFormat('dd MMM yyyy').format(start)}'
              ' - ${DateFormat('dd MMM yyyy').format(end)}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            // TOTAL DAYS
            Text(
              'Total: $totalDays days',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
