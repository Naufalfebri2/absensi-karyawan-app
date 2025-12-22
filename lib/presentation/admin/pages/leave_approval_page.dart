import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:absensi_karyawan_app/presentation/admin/leave/bloc/leave_approval_cubit.dart';
import 'package:absensi_karyawan_app/presentation/admin/leave/bloc/leave_approval_state.dart';
import 'package:absensi_karyawan_app/presentation/admin/widgets/leave_decision_dialog.dart';

class LeaveApprovalPage extends StatelessWidget {
  const LeaveApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approval Cuti'), centerTitle: true),
      body: BlocBuilder<LeaveApprovalCubit, LeaveApprovalState>(
        builder: (context, state) {
          // ===============================
          // LOADING
          // ===============================
          if (state is LeaveApprovalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ===============================
          // LOADED
          // ===============================
          if (state is LeaveApprovalLoaded) {
            if (state.leaves.isEmpty) {
              return const Center(child: Text('Tidak ada pengajuan cuti'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.leaves.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final leave = state.leaves[index];

                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      leave['employee_name'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${leave['leave_type']} | '
                      '${leave['start_date']} - ${leave['end_date']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ===============================
                        // APPROVE
                        // ===============================
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            showLeaveDecisionDialog(
                              context: context,
                              title: 'Setujui Pengajuan Cuti',
                              confirmLabel: 'Setujui',
                              confirmColor: Colors.green,
                              onConfirm: (note) {
                                context.read<LeaveApprovalCubit>().approve(
                                  leave['id'],
                                  note: note,
                                );
                              },
                            );
                          },
                        ),

                        // ===============================
                        // REJECT
                        // ===============================
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            showLeaveDecisionDialog(
                              context: context,
                              title: 'Tolak Pengajuan Cuti',
                              confirmLabel: 'Tolak',
                              confirmColor: Colors.red,
                              onConfirm: (note) {
                                context.read<LeaveApprovalCubit>().reject(
                                  leave['id'],
                                  note: note,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // ===============================
          // ERROR
          // ===============================
          if (state is LeaveApprovalError) {
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
}
