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

  @override
  void initState() {
    super.initState();
    // ===============================
    // LOAD DASHBOARD (PENDING LEAVE)
    // ===============================
    context.read<HomeCubit>().loadDashboard();
  }

  void onNavTap(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        // HOME (stay)
        break;

      case 1:
        // ===============================
        // CALENDAR PAGE ✅
        // ===============================
        context.push('/calendar');
        break;

      case 2:
        // ===============================
        // ATTENDANCE PAGE
        // ===============================
        context.push('/attendance');
        break;

      case 3:
        // ===============================
        // LEAVE HISTORY
        // ===============================
        context.push('/leave');
        break;

      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const brownColor = Color(0xFF623B00);

    return Scaffold(
      backgroundColor: Colors.white,

      // ===============================
      // APP BAR
      // ===============================
      appBar: AppBar(
        backgroundColor: brownColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 55,
      ),

      // ===============================
      // BODY
      // ===============================
      body: const Center(
        child: Text(
          "Home Placeholder",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),

      // ===============================
      // BOTTOM NAVIGATION BAR
      // ===============================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: brownColor,
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
              currentIndex: selectedIndex,
              onTap: onNavTap,
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

                // ===============================
                // LEAVE REQUEST + BADGE
                // ===============================
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
    );
  }
}
