import 'package:flutter/material.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isHoliday; // 🔥 TAMBAHAN
  final VoidCallback onTap;
  final double size;
  final double fontSize;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isHoliday, // 🔥 WAJIB
    required this.onTap,
    this.size = 32,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSunday = date.weekday == DateTime.sunday;

    Color textColor;
    Color backgroundColor = Colors.transparent;

    // ===============================
    // PRIORITAS WARNA
    // ===============================
    if (isSelected) {
      backgroundColor = const Color(0xFF624731); // coklat
      textColor = Colors.white;
    } else if (isHoliday) {
      textColor = Colors.red; // 🔥 TANGGAL MERAH LIBUR
    } else if (isSunday) {
      textColor = Colors.redAccent;
    } else {
      textColor = Colors.black;
    }

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
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
      ),
    );
  }
}
