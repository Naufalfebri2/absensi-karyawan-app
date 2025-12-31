import 'package:flutter/material.dart';

class LeaveDetailPage extends StatelessWidget {
  final Map<String, dynamic> leave;

  const LeaveDetailPage({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final status = (leave['status'] ?? 'pending').toString().toLowerCase();
    final statusColor = _statusColor(status);

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Status'),
            _statusBadge(status, statusColor),

            const SizedBox(height: 16),

            _sectionTitle('Leave Type'),
            _valueText(leave['leave_type'] ?? '-'),

            const SizedBox(height: 16),

            _sectionTitle('Date'),
            _valueText('${leave['start_date']} - ${leave['end_date']}'),

            const SizedBox(height: 16),

            _sectionTitle('Reason'),
            _valueText(leave['reason'] ?? '-'),

            const SizedBox(height: 16),

            if (leave['note'] != null &&
                leave['note'].toString().isNotEmpty) ...[
              _sectionTitle('Manager Notes'),
              _valueText(leave['note']),
            ],
          ],
        ),
      ),
    );
  }

  // ===============================
  // UI HELPERS
  // ===============================
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _valueText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
