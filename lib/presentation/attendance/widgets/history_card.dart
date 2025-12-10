import 'package:flutter/material.dart';
import '../../../core/extensions/date_ext.dart';
import '../../../domain/entities/attendance_entity.dart';

class HistoryCard extends StatelessWidget {
  final AttendanceEntity item;

  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final date = item.checkIn?.toShortDate() ?? "-";
    final checkInTime = item.checkIn?.formatTime() ?? "-";
    final checkOutTime = item.checkOut?.formatTime() ?? "-";

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 6),

            /// Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check In: $checkInTime"),
                Text("Check Out: $checkOutTime"),
              ],
            ),

            const SizedBox(height: 6),

            /// Status
            Text("Status: ${item.status}"),
          ],
        ),
      ),
    );
  }
}
