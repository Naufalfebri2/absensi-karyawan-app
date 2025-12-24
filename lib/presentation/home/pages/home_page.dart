import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onNavTap(int index) {
    if (index == selectedIndex) return;

    setState(() => selectedIndex = index);

    switch (index) {
      case 1:
        context.push('/calendar');
        break;
      case 2:
        context.push('/attendance');
        break;
      case 3:
        context.push('/leave');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF624731);
    const lightBrown = Color(0xFF957158);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===============================
            // HEADER
            // ===============================
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(color: brown),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ===============================
            // CONTENT
            // ===============================
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is! HomeLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final now = state.now;
                  final isCheckedIn = state.hasCheckedIn;

                  final canCheckIn = state.canCheckIn;
                  final canCheckOut = state.canCheckOut;

                  final restrictionMessage = state.restrictionMessage;
                  final gpsErrorMessage = state.gpsErrorMessage;
                  final isWithinOfficeRadius = state.isWithinOfficeRadius;
                  final distanceFromOffice = state.distanceFromOffice;

                  // ===============================
                  // FORMAT TIME (24 JAM WIB)
                  // ===============================
                  final timeText =
                      '${now.hour.toString().padLeft(2, '0')}:'
                      '${now.minute.toString().padLeft(2, '0')}:'
                      '${now.second.toString().padLeft(2, '0')}';

                  final dateText =
                      '${_weekday(now.weekday)}, '
                      '${now.day.toString().padLeft(2, '0')} '
                      '${_month(now.month)} '
                      '${now.year}';

                  // ===============================
                  // GPS VALIDATION
                  // ===============================
                  final bool isGpsValid =
                      gpsErrorMessage == null && isWithinOfficeRadius;

                  final bool buttonEnabled =
                      isGpsValid && (!isCheckedIn ? canCheckIn : canCheckOut);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // ===============================
                          // ATTENDANCE CARD
                          // ===============================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: brown,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  dateText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$timeText WIB',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      state.locationName,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                // ===============================
                                // GPS INFO
                                // ===============================
                                if (distanceFromOffice != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Jarak ke kantor: ${distanceFromOffice.toStringAsFixed(0)} m',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],

                                // ===============================
                                // ERROR / RESTRICTION MESSAGE
                                // ===============================
                                if (!buttonEnabled &&
                                    (restrictionMessage != null ||
                                        gpsErrorMessage != null)) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    gpsErrorMessage ?? restrictionMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 16),

                                // ===============================
                                // CHECK IN / CHECK OUT BUTTON
                                // ===============================
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    onPressed: buttonEnabled
                                        ? () async {
                                            final homeCubit = context
                                                .read<HomeCubit>();

                                            if (!isCheckedIn) {
                                              final result = await context.push(
                                                '/attendance/checkin',
                                              );
                                              if (result == true) {
                                                homeCubit.markCheckedIn();
                                              }
                                            } else {
                                              final result = await context.push(
                                                '/attendance/checkout',
                                              );
                                              if (result == true) {
                                                homeCubit.markCheckedOut();
                                              }
                                            }
                                          }
                                        : null,
                                    icon: Icon(
                                      isCheckedIn ? Icons.logout : Icons.login,
                                    ),
                                    label: Text(
                                      isCheckedIn ? 'Check Out' : 'Check In',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonEnabled
                                          ? (isCheckedIn
                                                ? Colors.red.shade400
                                                : lightBrown)
                                          : Colors.grey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===============================
      // BOTTOM NAVIGATION
      // ===============================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: brown,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onNavTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
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
      ),
    );
  }

  String _weekday(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }

  String _month(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
