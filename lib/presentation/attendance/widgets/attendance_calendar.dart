import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../bloc/attendance_cubit.dart';
import '../bloc/attendance_state.dart';

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, String> holidays;

  const AttendanceCalendar({super.key, required this.holidays});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final year = state.selectedYear;
        final month = state.selectedMonth;

        final firstDayOfMonth = DateTime(year, month, 1);
        final daysInMonth = DateTime(year, month + 1, 0).day;
        final startWeekday = firstDayOfMonth.weekday % 7;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // MONTH & YEAR HEADER (GOOGLE CALENDAR STYLE)
            // ===============================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Text(
                  _monthLabel(month),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  year.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

            // ===============================
            // WEEKDAY HEADER
            // ===============================
            Row(
              children: const [
                _Weekday('Su', isSunday: true),
                _Weekday('Mo'),
                _Weekday('Tu'),
                _Weekday('We'),
                _Weekday('Th'),
                _Weekday('Fr'),
                _Weekday('Sa'),
              ],
            ),

            const SizedBox(height: 8),

            // ===============================
            // CALENDAR GRID
            // ===============================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: startWeekday + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                if (index < startWeekday) {
                  return const SizedBox.shrink();
                }

                final day = index - startWeekday + 1;
                final date = DateTime(year, month, day);
                final normalized = DateTime(date.year, date.month, date.day);

                final isSunday = date.weekday == DateTime.sunday;
                final isHoliday = holidays.containsKey(normalized);
                final isSelected =
                    state.selectedDate != null &&
                    _isSameDate(state.selectedDate!, date);

                Color textColor = AppColors.textPrimary;
                Color? bgColor;

                if (isSelected) {
                  bgColor = AppColors.primary;
                  textColor = Colors.white;
                } else if (isSunday || isHoliday) {
                  textColor = Colors.red;
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    context.read<AttendanceCubit>().selectDate(
                      date: date,
                      holidayName: holidays[normalized],
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              },
            ),

            // ===============================
            // HOLIDAY INFO
            // ===============================
            if (state.selectedHolidayName != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Libur Nasional – ${state.selectedHolidayName}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthLabel(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
}

/// ===============================
/// WEEKDAY LABEL
/// ===============================
class _Weekday extends StatelessWidget {
  final String label;
  final bool isSunday;

  const _Weekday(this.label, {this.isSunday = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSunday ? Colors.red : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
