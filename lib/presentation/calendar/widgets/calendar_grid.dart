import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_cubit.dart';
import '../bloc/calendar_state.dart';
import 'calendar_day_cell.dart';

// 🔥 HOLIDAY
import '../../../data/datasources/local/holiday_local.dart';
import '../../../core/utils/holiday_utils.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
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

        // Sunday = 0, Monday = 1 ...
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
              _buildMonthYearSelector(context, state),
              const SizedBox(height: 8),

              // ===============================
              // DAY HEADER
              // ===============================
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  // EMPTY CELL (OFFSET)
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

                  final isHoliday = HolidayUtils.isHoliday(
                    date,
                    HolidayLocal.holidays,
                  );

                  // 🔥 AMBIL LEAVE DI TANGGAL INI
                  final leaves = state.leaveMap[date] ?? [];

                  return CalendarDayCell(
                    date: date,
                    isSelected: isSelected,
                    isHoliday: isHoliday,
                    size: 28,
                    fontSize: 12,

                    // ===============================
                    // 🔥 KUNCI UPGRADE
                    // ===============================
                    avatarUrls: leaves
                        .map((e) => e.employeeAvatar)
                        .where((e) => e.isNotEmpty)
                        .toList(),

                    leaveTypes: leaves.map((e) => e.leaveType).toList(),

                    hasEvent: leaves.isNotEmpty,

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
  Widget _buildMonthYearSelector(BuildContext context, CalendarState state) {
    const months = [
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.read<CalendarCubit>().previousMonth(),
        ),

        DropdownButton<int>(
          value: state.selectedMonth,
          underline: const SizedBox(),
          isDense: true,
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(months[index]),
            );
          }),
          onChanged: (month) {
            if (month == null) return;
            context.read<CalendarCubit>().changeMonth(month);
          },
        ),

        const SizedBox(width: 4),

        DropdownButton<int>(
          value: state.selectedYear,
          underline: const SizedBox(),
          isDense: true,
          items: state.availableYears
              .map(
                (year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
              )
              .toList(),
          onChanged: (year) {
            if (year == null) return;
            context.read<CalendarCubit>().changeYear(year);
          },
        ),

        IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_right),
          onPressed: () => context.read<CalendarCubit>().nextMonth(),
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
