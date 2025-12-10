import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_overlay.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../bloc/leave_cubit.dart';
import '../widgets/leave_card.dart';

class LeaveListPage extends StatefulWidget {
  const LeaveListPage({super.key});

  @override
  State<LeaveListPage> createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthCubit>().state;
    if (auth.employeeId != null) {
      context.read<LeaveCubit>().loadLeaves(auth.employeeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Izin")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "/leave-form"),
      ),

      body: BlocConsumer<LeaveCubit, LeaveState>(
        listener: (context, state) {
          if (state.isLoading)
            LoadingOverlay.showOverlay(context);
          else
            LoadingOverlay.hideOverlay();
        },
        builder: (context, state) {
          if (state.leaves.isEmpty && !state.isLoading) {
            return const Center(child: Text("Belum ada data izin"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.leaves.length,
            itemBuilder: (_, i) {
              return LeaveCard(item: state.leaves[i]);
            },
          );
        },
      ),
    );
  }
}
