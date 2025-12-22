import 'package:flutter/material.dart';
import '../bloc/calendar_state.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;

  const CalendarEventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(event.avatarUrl)),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(event.subtitle),
      ),
    );
  }
}
