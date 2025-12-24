// import 'package:flutter/material.dart';
// import '../../../config/theme/app_colors.dart';

// class CalendarMonthPicker extends StatelessWidget {
//   final int selectedMonth;
//   final int selectedYear;
//   final ValueChanged<int> onMonthChanged;
//   final ValueChanged<int> onYearChanged;
//   final VoidCallback onPrevMonth;
//   final VoidCallback onNextMonth;

//   const CalendarMonthPicker({
//     super.key,
//     required this.selectedMonth,
//     required this.selectedYear,
//     required this.onMonthChanged,
//     required this.onYearChanged,
//     required this.onPrevMonth,
//     required this.onNextMonth,
//   });

//   static const List<String> _months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final currentYear = DateTime.now().year;

//     // 🔥 YEAR RANGE: 1990 → CURRENT YEAR
//     final years = List.generate(
//       currentYear - 1990 + 1,
//       (index) => 1990 + index,
//     );

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // ===============================
//           // PREV MONTH
//           // ===============================
//           IconButton(
//             icon: const Icon(Icons.chevron_left),
//             onPressed: onPrevMonth,
//           ),

//           // ===============================
//           // MONTH DROPDOWN
//           // ===============================
//           DropdownButtonHideUnderline(
//             child: DropdownButton<int>(
//               value: selectedMonth,
//               items: List.generate(
//                 12,
//                 (index) => DropdownMenuItem(
//                   value: index + 1,
//                   child: Text(
//                     _months[index],
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               onChanged: (value) {
//                 if (value != null) {
//                   onMonthChanged(value);
//                 }
//               },
//             ),
//           ),

//           // ===============================
//           // YEAR DROPDOWN
//           // ===============================
//           DropdownButtonHideUnderline(
//             child: DropdownButton<int>(
//               value: selectedYear,
//               items: years.map((year) {
//                 return DropdownMenuItem(
//                   value: year,
//                   child: Text(
//                     year.toString(),
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   onYearChanged(value);
//                 }
//               },
//             ),
//           ),

//           // ===============================
//           // NEXT MONTH
//           // ===============================
//           IconButton(
//             icon: const Icon(Icons.chevron_right),
//             onPressed: onNextMonth,
//           ),
//         ],
//       ),
//     );
//   }
// }
