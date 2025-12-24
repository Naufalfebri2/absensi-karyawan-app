import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../bloc/attendance_cubit.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_card.dart';
import '../widgets/attendance_calendar.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ❗ Cubit SUDAH disediakan oleh app_router.dart
    return const _AttendanceView();
  }
}

class _AttendanceView extends StatelessWidget {
  const _AttendanceView();

  // ===============================
  // OPEN CALENDAR
  // ===============================
  void _openCalendar(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: const AttendanceCalendar(),
              );
            },
          ),
        );
      },
    );
  }

  // ===============================
  // BOTTOM NAV
  // ===============================
  int _getIndexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/leave')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    final router = GoRouter.of(context);

    switch (index) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/calendar');
        break;
      case 2:
        router.go('/attendance');
        break;
      case 3:
        router.go('/leave');
        break;
      case 4:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ===============================
            // HEADER
            // ===============================
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Attendance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white),
                ],
              ),
            ),

            // ===============================
            // CONTENT
            // ===============================
            Expanded(
              child: BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  final cubit = context.read<AttendanceCubit>();
                  final records = cubit.visibleRecords;

                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      // TITLE + MONTH PICKER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Attendance History",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => _openCalendar(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _monthLabel(
                                      state.selectedMonth,
                                      state.selectedYear,
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // FILTER
                      Wrap(
                        spacing: 8,
                        children: AttendanceFilter.values.map((filter) {
                          final isSelected = state.filter == filter;

                          return GestureDetector(
                            onTap: () => cubit.changeFilter(filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                _filterLabel(filter),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // SELECTED DATE INFO
                      if (state.selectedDate != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            state.selectedHolidayName != null
                                ? "Libur Nasional - ${state.selectedHolidayName}"
                                : "Tanggal: ${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),

                      // LIST
                      ...records.map((e) => AttendanceCard(attendance: e)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===============================
      // BOTTOM NAV
      // ===============================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getIndexFromLocation(context),
        onTap: (index) => _onNavTap(context, index),
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Attendance",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Leave"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ===============================
  // HELPERS
  // ===============================
  static String _monthLabel(int month, int year) {
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
    return "${months[month - 1]} $year";
  }

  static String _filterLabel(AttendanceFilter filter) {
    switch (filter) {
      case AttendanceFilter.all:
        return "All";
      case AttendanceFilter.onTime:
        return "On Time";
      case AttendanceFilter.leave:
        return "Leave";
      case AttendanceFilter.holiday:
        return "Holiday";
    }
  }
}
