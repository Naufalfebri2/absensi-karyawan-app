import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/leave_cubit.dart';
import '../bloc/leave_state.dart';
import '../widgets/leave_card.dart';
import '../../../domain/entities/leave_entity.dart';

class LeaveListPage extends StatelessWidget {
  const LeaveListPage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave History')),
      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          // LOADING
          if (state is LeaveLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // DATA LOADED
          if (state is LeaveLoaded) {
            if (state.leaves.isEmpty) {
              return const Center(child: Text('No leave requests yet'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.leaves.length,
              itemBuilder: (context, index) {
                final LeaveEntity leave = state.leaves[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LeaveCard(
                    leaveType: leave.leaveType,
                    startDate: _formatDate(leave.startDate),
                    endDate: _formatDate(leave.endDate),
                    totalDays: leave.totalDays,
                    status: leave.status,
                  ),
                );
              },
            );
          }

          // ERROR
          if (state is LeaveError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
