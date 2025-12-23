import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../config/theme/app_colors.dart';

import '../../../data/datasources/local/attendance_local.dart';
import '../../../data/repositories/attendance_repository_impl.dart';
import '../../../domain/repositories/attendance_repository.dart';

import '../../../core/services/holiday/holiday_service.dart';

import '../bloc/attendance_cubit.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_card.dart';
import '../widgets/attendance_calendar.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AttendanceRepository>(
      create: (_) => AttendanceRepositoryImpl(
        localDataSource: AttendanceLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) =>
            AttendanceCubit(repository: context.read<AttendanceRepository>()),
        child: const _AttendanceView(),
      ),
    );
  }
}

class _AttendanceView extends StatefulWidget {
  const _AttendanceView();

  @override
  State<_AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<_AttendanceView> {
  final HolidayService _holidayService = HolidayService(Dio());
  Map<DateTime, String> _holidays = {};

  // ===============================
  // LOAD HOLIDAY BY YEAR
  // ===============================
  Future<void> _loadHolidays(int year) async {
    final data = await _holidayService.getNationalHolidays(year);
    if (!mounted) return;
    setState(() => _holidays = data);
  }

  // ===============================
  // OPEN GOOGLE CALENDAR
  // ===============================
  void _openCalendar(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();

    _loadHolidays(cubit.state.selectedYear);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocListener<AttendanceCubit, AttendanceState>(
            listenWhen: (prev, curr) => prev.selectedYear != curr.selectedYear,
            listener: (context, state) {
              _loadHolidays(state.selectedYear);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: AttendanceCalendar(holidays: _holidays),
            ),
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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
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
                  final records = cubit.filteredRecords;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            final count = _getFilterCount(
                              filter,
                              state.records,
                            );

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
                                  '($count) ${_filterLabel(filter)}',
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

                        // LIST
                        ...records.map((e) => AttendanceCard(attendance: e)),
                      ],
                    ),
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

  static int _getFilterCount(AttendanceFilter filter, List records) {
    switch (filter) {
      case AttendanceFilter.all:
        return records.length;
      case AttendanceFilter.onTime:
        return records.where((e) => e.isOnTime).length;
      case AttendanceFilter.leave:
        return records.where((e) => e.isLeave).length;
      case AttendanceFilter.holiday:
        return records.where((e) => e.isHoliday).length;
    }
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
