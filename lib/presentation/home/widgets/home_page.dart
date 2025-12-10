import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_cubit.dart';
import '../../auth/bloc/auth_state.dart';
import '../widgets/header_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Loading saat cek session
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Beranda'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await context.read<AuthCubit>().logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<AuthCubit>().loadSession(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // =========================
                // HEADER PROFILE
                // =========================
                HeaderProfile(
                  name: state.fullName ?? '-',
                  role: state.role ?? '-',
                  photoUrl: null, // nanti isi dari backend
                ),
                const SizedBox(height: 20),

                // =========================
                // MENU GRID
                // =========================
                const Text(
                  'Menu Utama',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildMenuGrid(context),
                const SizedBox(height: 30),

                // =========================
                // RINGKASAN HARI INI (dummy)
                // =========================
                _buildTodaySummaryCard(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================
  // MENU GRID
  // ================================
  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {'title': 'Check In', 'icon': Icons.login, 'route': '/checkin'},
      {'title': 'Check Out', 'icon': Icons.logout, 'route': '/checkout'},
      {
        'title': 'Riwayat',
        'icon': Icons.history,
        'route': '/attendance-history',
      },
      {'title': 'Izin', 'icon': Icons.calendar_month, 'route': '/leave-list'},
      {'title': 'Shift', 'icon': Icons.schedule, 'route': '/shift-calendar'},
      {
        'title': 'Notifikasi',
        'icon': Icons.notifications,
        'route': '/notifications',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item['route'] as String);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, size: 32, color: Colors.blue),
                const SizedBox(height: 10),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================
  // RINGKASAN HARI INI (dummy)
  // ================================
  Widget _buildTodaySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Hari Ini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _SummaryItem(label: 'Check In', value: '--:--'),
              _SummaryItem(label: 'Check Out', value: '--:--'),
              _SummaryItem(label: 'Status', value: '—'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
