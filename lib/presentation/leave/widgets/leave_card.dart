import 'package:flutter/material.dart';
import '../../../domain/entities/leave_entity.dart';

class LeaveCard extends StatelessWidget {
  final LeaveEntity item;

  const LeaveCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(item.type),
        subtitle: Text(item.reason),
        trailing: Text(item.status),
      ),
    );
  }
}
