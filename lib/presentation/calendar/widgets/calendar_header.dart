import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF624731),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 LOGO (GANTI AVATAR)
          Image.asset(
            'assets/images/logo.png',
            height: 36,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          const Text(
            "Calendar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }
}
