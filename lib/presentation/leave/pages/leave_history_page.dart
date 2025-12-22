import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/leave_cubit.dart';
import '../bloc/leave_state.dart';
import 'leave_form_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave'),
        centerTitle: true,
        actions: [
          PopupMenuButton<LeaveFilter>(
            onSelected: (value) {
              setState(() => selectedFilter = value);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: LeaveFilter.all, child: Text('Semua')),
              PopupMenuItem(value: LeaveFilter.pending, child: Text('Pending')),
              PopupMenuItem(
                value: LeaveFilter.approved,
                child: Text('Approved'),
              ),
              PopupMenuItem(
                value: LeaveFilter.rejected,
                child: Text('Rejected'),
              ),
            ],
          ),
        ],
      ),

      // ===============================
      // AJUKAN CUTI
      // ===============================
      floatingActionButton: FloatingActionButton.extended(
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
          ).then((_) {
            // 🔥 WAJIB: refresh setelah kembali
            context.read<LeaveCubit>().fetchLeaves();
          });
        },
      ),

      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          // ===============================
          // LOADING
          // ===============================
          if (state is LeaveLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ===============================
          // LOADED
          // ===============================
          if (state is LeaveLoaded) {
            if (state.leaves.isEmpty) {
              return const Center(child: Text('Belum ada riwayat cuti'));
            }

            final filteredLeaves = state.leaves.where((leave) {
              final status = (leave['status'] ?? 'pending')
                  .toString()
                  .toLowerCase();

              if (selectedFilter == LeaveFilter.all) return true;
              return status.contains(selectedFilter.name);
            }).toList();

            if (filteredLeaves.isEmpty) {
              return const Center(child: Text('Tidak ada data sesuai filter'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredLeaves.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final leave = filteredLeaves[index];
                final status = (leave['status'] ?? 'pending')
                    .toString()
                    .toLowerCase();
                final statusColor = _statusColor(status);

                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      leave['leave_type'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${leave['start_date']} - ${leave['end_date']}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
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

          // ===============================
          // ERROR
          // ===============================
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
      ),
    );
  }

  // ===============================
  // STATUS COLOR
  // ===============================
  Color _statusColor(String status) {
    if (status.contains('approved')) return Colors.green;
    if (status.contains('rejected')) return Colors.red;
    return Colors.orange; // pending
  }
}
