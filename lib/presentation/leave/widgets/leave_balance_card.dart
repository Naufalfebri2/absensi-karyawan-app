import 'package:flutter/material.dart';

class LeaveBalanceCard extends StatelessWidget {
  final int? totalLeave;
  final int? remainingLeave;
  final VoidCallback onRequestLeave;

  const LeaveBalanceCard({
    super.key,
    required this.totalLeave,
    required this.remainingLeave,
    required this.onRequestLeave,
  });

  @override
  Widget build(BuildContext context) {
    // Jika backend belum mengirim data balance
    if (totalLeave == null || remainingLeave == null) {
      return const SizedBox.shrink();
    }

    final usedLeave = totalLeave! - remainingLeave!;
    final progress = totalLeave! == 0 ? 0.0 : usedLeave / totalLeave!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================
          // TITLE
          // =====================
          const Text(
            'Annual Leave Balance',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          // =====================
          // BALANCE TEXT
          // =====================
          Text(
            '$remainingLeave / $totalLeave days remaining',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // =====================
          // PROGRESS BAR
          // =====================
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Theme.of(
                context,
              ).dividerColor.withValues(alpha: 0.3),
            ),
          ),

          const SizedBox(height: 16),

          // =====================
          // CTA BUTTON
          // =====================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: remainingLeave! > 0 ? onRequestLeave : null,
              icon: const Icon(Icons.add),
              label: const Text('Leave Request'),
            ),
          ),
        ],
      ),
    );
  }
}
