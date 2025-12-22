import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_cubit.dart';
import '../bloc/calendar_state.dart';
import 'calendar_day_cell.dart';

// 🔥 HR HOLIDAY
import '../../../data/datasources/local/holiday_local.dart';
import '../../../core/utils/holiday_utils.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, CalendarState state) {
        final focusedMonth = state.focusedMonth;
        final selectedDate = state.selectedDate;

        final firstDayOfMonth = DateTime(
          focusedMonth.year,
          focusedMonth.month,
          1,
        );

        final daysInMonth = DateTime(
          focusedMonth.year,
          focusedMonth.month + 1,
          0,
        ).day;

        final startWeekday = firstDayOfMonth.weekday % 7;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMonthYearSelector(context, focusedMonth),
              const SizedBox(height: 8),

              // ===============================
              // DAY HEADER
              // ===============================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _DayLabel("Su", isSunday: true),
                  _DayLabel("Mo"),
                  _DayLabel("Tu"),
                  _DayLabel("We"),
                  _DayLabel("Th"),
                  _DayLabel("Fr"),
                  _DayLabel("Sa"),
                ],
              ),

              const SizedBox(height: 6),

              // ===============================
              // DATE GRID
              // ===============================
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daysInMonth + startWeekday,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  if (index < startWeekday) {
                    return const SizedBox();
                  }

                  final day = index - startWeekday + 1;
                  final date = DateTime(
                    focusedMonth.year,
                    focusedMonth.month,
                    day,
                  );

                  final isSelected = _isSameDate(date, selectedDate);

                  // 🔥 CEK LIBUR NASIONAL
                  final isHoliday = HolidayUtils.isHoliday(
                    date,
                    HolidayLocal.holidays,
                  );

                  return CalendarDayCell(
                    date: date,
                    isSelected: isSelected,
                    isHoliday: isHoliday, // 🔥 PENTING
                    size: 28,
                    fontSize: 12,
                    onTap: () => context.read<CalendarCubit>().selectDate(date),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ===============================
  // MONTH & YEAR SELECTOR
  // ===============================
  Widget _buildMonthYearSelector(BuildContext context, DateTime focusedMonth) {
    final months = const [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final currentYear = DateTime.now().year;
    final years = List.generate(11, (i) => currentYear - 5 + i);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            context.read<CalendarCubit>().changeMonth(
              DateTime(focusedMonth.year, focusedMonth.month - 1),
            );
          },
        ),

        DropdownButton<int>(
          value: focusedMonth.month,
          underline: const SizedBox(),
          isDense: true,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(months[index]),
            );
          }),
          onChanged: (month) {
            if (month == null) return;
            context.read<CalendarCubit>().changeMonth(
              DateTime(focusedMonth.year, month),
            );
          },
        ),

        const SizedBox(width: 4),

        DropdownButton<int>(
          value: focusedMonth.year,
          underline: const SizedBox(),
          isDense: true,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          items: years
              .map(
                (year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
              )
              .toList(),
          onChanged: (year) {
            if (year == null) return;
            context.read<CalendarCubit>().changeMonth(
              DateTime(year, focusedMonth.month),
            );
          },
        ),

        IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            context.read<CalendarCubit>().changeMonth(
              DateTime(focusedMonth.year, focusedMonth.month + 1),
            );
          },
        ),
      ],
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// ===============================
// DAY LABEL
// ===============================
class _DayLabel extends StatelessWidget {
  final String label;
  final bool isSunday;

  const _DayLabel(this.label, {this.isSunday = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSunday ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
