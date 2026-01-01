import 'package:flutter/material.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isHoliday;
  final VoidCallback onTap;

  // ===============================
  // UPGRADE
  // ===============================
  final List<String> avatarUrls;
  final List<String> leaveTypes; // ⬅️ NEW
  final bool hasEvent;

  final double size;
  final double fontSize;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isHoliday,
    required this.onTap,

    this.avatarUrls = const [],
    this.leaveTypes = const [], // ⬅️ DEFAULT AMAN
    this.hasEvent = false,

    this.size = 36,
    this.fontSize = 14,
  });

  // ===============================
  // COLOR BY LEAVE TYPE
  // ===============================
  Color _leaveColor(String type) {
    final value = type.toLowerCase();

    if (value.contains('sakit')) return Colors.red;
    if (value.contains('izin')) return Colors.green;
    if (value.contains('cuti')) return Colors.blue;

    return Colors.orange; // lainnya
  }

  @override
  Widget build(BuildContext context) {
    final bool isSunday = date.weekday == DateTime.sunday;

    Color textColor;
    Color backgroundColor = Colors.transparent;

    // ===============================
    // PRIORITAS WARNA TANGGAL
    // ===============================
    if (isSelected) {
      backgroundColor = const Color(0xFF624731);
      textColor = Colors.white;
    } else if (isHoliday) {
      textColor = Colors.red;
    } else if (isSunday) {
      textColor = Colors.redAccent;
    } else {
      textColor = Colors.black;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ===============================
          // DAY NUMBER
          // ===============================
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isHoliday ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ===============================
          // AVATAR STACK (MAX 3)
          // ===============================
          if (avatarUrls.isNotEmpty)
            SizedBox(
              height: 18,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < avatarUrls.length && i < 3; i++)
                    Positioned(
                      left: i * 10,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: _leaveColor(
                          i < leaveTypes.length ? leaveTypes[i] : '',
                        ),
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(avatarUrls[i]),
                        ),
                      ),
                    ),

                  if (avatarUrls.length > 3)
                    Positioned(
                      left: 3 * 10,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          '+${avatarUrls.length - 3}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          // ===============================
          // EVENT DOT (COLOR BY TYPE)
          // ===============================
          else if (hasEvent && leaveTypes.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _leaveColor(leaveTypes.first),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
