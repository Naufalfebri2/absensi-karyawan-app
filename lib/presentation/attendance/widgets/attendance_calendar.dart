import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/attendance_cubit.dart';
import '../bloc/attendance_state.dart';

class AttendanceCalendar extends StatelessWidget {
  const AttendanceCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final year = state.selectedYear;
        final month = state.selectedMonth;
        final holidays = state.holidays;

        final firstDayOfMonth = DateTime(year, month, 1);
        final daysInMonth = DateUtils.getDaysInMonth(year, month);
        final firstWeekday = firstDayOfMonth.weekday; // Mon = 1

        final leadingEmptyDays = (firstWeekday - 1) % 7;
        final totalCells = leadingEmptyDays + daysInMonth;

        // ===== RANGE TAHUN =====
        final startYear = 1990;
        final endYear = DateTime.now().year + 10;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // HEADER: <  MONTH ▼  YEAR ▼  >
            // ===================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // PREVIOUS MONTH
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final prev = DateTime(year, month - 1);
                    context.read<AttendanceCubit>().changeMonth(
                      year: prev.year,
                      month: prev.month,
                    );
                  },
                ),

                // MONTH & YEAR DROPDOWN
                Row(
                  children: [
                    // ---------- MONTH ----------
                    DropdownButton<int>(
                      value: month,
                      underline: const SizedBox(),
                      items: List.generate(12, (i) {
                        final m = i + 1;
                        return DropdownMenuItem(
                          value: m,
                          child: Text(
                            DateFormat('MMMM').format(DateTime(2025, m)),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<AttendanceCubit>().changeMonth(
                          year: year,
                          month: value,
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    // ---------- YEAR ----------
                    DropdownButton<int>(
                      value: year,
                      underline: const SizedBox(),
                      items: List.generate(endYear - startYear + 1, (i) {
                        final y = startYear + i;
                        return DropdownMenuItem(
                          value: y,
                          child: Text(
                            y.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<AttendanceCubit>().changeMonth(
                          year: value,
                          month: month,
                        );
                      },
                    ),
                  ],
                ),

                // NEXT MONTH
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final next = DateTime(year, month + 1);
                    context.read<AttendanceCubit>().changeMonth(
                      year: next.year,
                      month: next.month,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ===================================================
            // WEEKDAY HEADER
            // ===================================================
            Row(
              children: const [
                _Weekday('Mon'),
                _Weekday('Tue'),
                _Weekday('Wed'),
                _Weekday('Thu'),
                _Weekday('Fri'),
                _Weekday('Sat'),
                _Weekday('Sun'),
              ],
            ),

            const SizedBox(height: 8),

            // ===================================================
            // CALENDAR GRID + SWIPE
            // ===================================================
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;

                if (details.primaryVelocity! < 0) {
                  // swipe left → next month
                  final next = DateTime(year, month + 1);
                  context.read<AttendanceCubit>().changeMonth(
                    year: next.year,
                    month: next.month,
                  );
                } else {
                  // swipe right → prev month
                  final prev = DateTime(year, month - 1);
                  context.read<AttendanceCubit>().changeMonth(
                    year: prev.year,
                    month: prev.month,
                  );
                }
              },
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: totalCells,
                itemBuilder: (context, index) {
                  if (index < leadingEmptyDays) {
                    return const SizedBox.shrink();
                  }

                  final day = index - leadingEmptyDays + 1;
                  final date = DateTime(year, month, day);
                  final normalized = DateTime(date.year, date.month, date.day);

                  final isSelected =
                      state.selectedDate != null &&
                      DateUtils.isSameDay(state.selectedDate, date);

                  final holidayName = holidays[normalized];
                  final isHoliday = holidayName != null;

                  return GestureDetector(
                    onTap: () {
                      context.read<AttendanceCubit>().selectDate(
                        date,
                        holidayName: holidayName,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : isHoliday
                            ? Colors.red.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : isHoliday
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ===================================================
            // HOLIDAY TEXT
            // ===================================================
            if (state.selectedHolidayName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Libur Nasional: ${state.selectedHolidayName}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Weekday extends StatelessWidget {
  final String label;
  const _Weekday(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }
}
