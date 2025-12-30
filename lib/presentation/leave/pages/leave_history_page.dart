import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../bloc/leave_cubit.dart';
import '../bloc/leave_state.dart';
import 'leave_form_page.dart';
import '../../../domain/entities/leave_entity.dart';

enum LeaveFilter { all, pending, approved, rejected }

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  LeaveFilter selectedFilter = LeaveFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<LeaveCubit>().fetchLeaves();
  }

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
    if (_getIndexFromLocation(context) == index) return;

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
    return BlocListener<LeaveCubit, LeaveState>(
      listener: (context, state) {
        if (state is LeaveSuccess) {
          context.read<LeaveCubit>().fetchLeaves();
        }

        if (state is LeaveError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
        floatingActionButton: _buildFab(),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        if (state is LeaveLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LeaveLoaded) {
          final List<LeaveEntity> leaves = List<LeaveEntity>.from(state.leaves);

          if (leaves.isEmpty) {
            return const Center(child: Text('Belum ada riwayat cuti'));
          }

          final filteredLeaves = leaves.where((leave) {
            final status = leave.status.toLowerCase();

            if (selectedFilter == LeaveFilter.all) return true;
            return status == selectedFilter.name;
          }).toList();

          if (filteredLeaves.isEmpty) {
            return const Center(child: Text('Tidak ada data sesuai filter'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: filteredLeaves.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final leave = filteredLeaves[index];
              final status = leave.status.toLowerCase();
              final color = _statusColor(status);

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    leave.leaveType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${leave.startDate} - ${leave.endDate}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        if (state is LeaveError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader() {
    return Container(
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
          // LOGO / AVATAR
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),

          // TITLE
          const Expanded(
            child: Center(
              child: Text(
                "Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // NOTIFICATION ICON
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // arahkan ke halaman notifikasi jika sudah ada
              // context.go('/notifications');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('Ajukan Cuti'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<LeaveCubit>(),
              child: const LeaveFormPage(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }

  Color _statusColor(String status) {
    if (status == 'approved') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
  }
}
