import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/attendance_history_cubit.dart';
import '../widgets/history_card.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  void initState() {
    super.initState();

    // TODO: ganti employeeId dari session user login
    context.read<AttendanceHistoryCubit>().loadHistory(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Absensi")),
      body: BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
        builder: (context, state) {
          if (state is AttendanceHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceHistoryError) {
            return Center(child: Text(state.message));
          }

          if (state is AttendanceHistorySuccess) {
            if (state.list.isEmpty) {
              return const Center(child: Text("Tidak ada riwayat absen."));
            }

            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, i) {
                return HistoryCard(item: state.list[i]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
