import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

import '../widgets/animated_clock.dart';
import '../widgets/summary_item_card.dart';

import '../../attendance/bloc/attendance_cubit.dart';
import '../../attendance/bloc/attendance_state.dart';

import '../../notifications/bloc/notification_cubit.dart';
import '../../notifications/bloc/notification_state.dart';
import '../../auth/bloc/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/leave')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

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
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeCubit>().ensureAutoRefresh();
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
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        ImageProvider imageProvider;
                        if (state is AuthAuthenticated &&
                            state.user.avatarUrl != null &&
                            state.user.avatarUrl!.isNotEmpty) {
                          imageProvider = NetworkImage(
                            "${state.user.avatarUrl!}?v=${DateTime.now().millisecondsSinceEpoch}",
                          );
                        } else {
                          imageProvider = const AssetImage(
                            'assets/images/logo.png',
                          );
                        }

                        return CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        );
                      },
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
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, notifState) {
                      int unreadCount = 0;
                      if (notifState is NotificationLoaded) {
                        unreadCount = notifState.unreadCount;
                      }

                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () => context.push('/notifications'),
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
                  final isCheckedOut = state.hasCheckedOut;
                  final canCheckIn = state.canCheckIn;
                  final canCheckOut = state.canCheckOut;
                  final restrictionMessage = state.restrictionMessage;
                  final distanceFromOffice = state.distanceFromOffice;

                  final buttonEnabled = !isCheckedIn ? canCheckIn : canCheckOut;

                  final dateText =
                      '${_weekday(now.weekday)}, '
                      '${now.day.toString().padLeft(2, '0')} '
                      '${_month(now.month)} '
                      '${now.year}';

                  return SingleChildScrollView(
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
                              AnimatedClock(
                                now: now,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              if (distanceFromOffice != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Distance to office: ${distanceFromOffice.toStringAsFixed(0)} m',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              if (restrictionMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  restrictionMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              if (isCheckedOut) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  'You have already checked out today',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
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
                                            if (!context.mounted) return;
                                            if (result != null) {
                                              homeCubit.markCheckedIn();
                                              homeCubit.refresh();
                                              context
                                                  .read<NotificationCubit>()
                                                  .loadNotifications();
                                            }
                                          } else {
                                            final result = await context.push(
                                              '/attendance/checkout',
                                            );
                                            if (!context.mounted) return;
                                            if (result is Map) {
                                              final checkOutTime =
                                                  result['checkOutTime']
                                                      as DateTime?;
                                              if (checkOutTime != null) {
                                                homeCubit.refresh();
                                                context
                                                    .read<AttendanceCubit>()
                                                    .syncAfterCheckOut(
                                                      checkOutTime:
                                                          checkOutTime,
                                                    );
                                                context
                                                    .read<NotificationCubit>()
                                                    .loadNotifications();
                                              }
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

                        // ===============================
                        // THIS MONTH SUMMARY (HISTORICAL)
                        // ===============================
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'This Month Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: brown,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryItemCard(
                                label: 'Present',
                                value: state.presentCount,
                                icon: Icons.check_circle,
                                color: Colors.green,
                                onTap: () {
                                  context.push(
                                    '/attendance',
                                    extra: {
                                      'month': state.now.month,
                                      'year': state.now.year,
                                      'status': AttendanceFilter.onTime,
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: SummaryItemCard(
                                label: 'Late',
                                value: state.lateCount,
                                icon: Icons.access_time,
                                color: Colors.orange,
                                onTap: () {
                                  context.push(
                                    '/attendance',
                                    extra: {
                                      'month': state.now.month,
                                      'year': state.now.year,
                                      'status': AttendanceFilter.onTime,
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: SummaryItemCard(
                                label: 'Absent',
                                value: state.absentCount,
                                icon: Icons.cancel,
                                color: Colors.red,
                                onTap: () {
                                  context.push(
                                    '/attendance',
                                    extra: {
                                      'month': state.now.month,
                                      'year': state.now.year,
                                      'status': AttendanceFilter.all,
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: SummaryItemCard(
                                label: 'Overtime',
                                value: state.overtimeCount,
                                icon: Icons.trending_up,
                                color: Colors.blue,
                                onTap: () {
                                  context.push(
                                    '/attendance',
                                    extra: {
                                      'month': state.now.month,
                                      'year': state.now.year,
                                      'status': AttendanceFilter.all,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
        currentIndex: _currentIndex(context),
        onTap: (index) => _onNavTap(context, index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: brown,
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
