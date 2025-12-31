import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../home/bloc/home_cubit.dart';
import '../../home/bloc/home_state.dart';

import '../bloc/calendar_cubit.dart';
import '../bloc/calendar_state.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_event_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // ===============================
  // ROUTE-BASED CURRENT INDEX
  // ===============================
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/leave')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

  // ===============================
  // NAV HANDLER (FIXED)
  // ===============================
  void _onNavTap(BuildContext context, int index) {
    if (_currentIndex(context) == index) return;

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
    return BlocProvider(
      create: (_) => CalendarCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
            children: const [
              CalendarHeader(),
              SizedBox(height: 12),
              CalendarGrid(),
              SizedBox(height: 12),
              Expanded(child: CalendarEventList()),
            ],
          ),
        ),

        // ===============================
        // BOTTOM NAV (FIXED & SYNC)
        // ===============================
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF624731), // Brown Figma
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              int pendingCount = 0;

              if (state is HomeLoaded) {
                pendingCount = state.pendingLeaveCount;
              }

              return BottomNavigationBar(
                currentIndex: _currentIndex(context),
                onTap: (index) => _onNavTap(context, index),
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month),
                    label: "Calendar",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.access_time),
                    label: "Attendance",
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.mail),
                        if (pendingCount > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.red,
                              child: Text(
                                pendingCount.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: "Leave",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// =======================================================
// EVENT LIST (TIDAK DIUBAH)
// =======================================================
class CalendarEventList extends StatelessWidget {
  const CalendarEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text(
              "${_weekday(state.selectedDate)}, "
              "${state.selectedDate.day} "
              "${_month(state.selectedDate.month)} "
              "${state.selectedDate.year}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            if (state.isHoliday)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_busy, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.holidayName != null
                            ? "National Holday – ${state.holidayName}"
                            : "National Holday",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (state.isHoliday) const SizedBox(height: 12),

            if (state.events.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  "No events on this date",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...state.events.map((e) => CalendarEventCard(e)),
          ],
        );
      },
    );
  }

  String _weekday(DateTime d) => const [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ][d.weekday % 7];

  String _month(int m) => const [
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
  ][m - 1];
}
