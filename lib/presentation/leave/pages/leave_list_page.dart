import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/leave_cubit.dart';
import '../bloc/leave_state.dart';
import '../widgets/leave_card.dart';

class LeaveListPage extends StatelessWidget {
  const LeaveListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Cuti')),
      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          // LOADING
          if (state is LeaveLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // DATA LOADED
          if (state is LeaveLoaded) {
            if (state.leaves.isEmpty) {
              return const Center(child: Text('Belum ada pengajuan cuti'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.leaves.length,
              itemBuilder: (context, index) {
                final leave = state.leaves[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LeaveCard(
                    leaveType: leave['leave_type'],
                    startDate: leave['start_date'],
                    endDate: leave['end_date'],
                    totalDays: leave['total_days'],
                    status: leave['status'],
                  ),
                );
              },
            );
          }

          // ERROR
          if (state is LeaveError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
