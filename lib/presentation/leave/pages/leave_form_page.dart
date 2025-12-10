import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_overlay.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../bloc/leave_cubit.dart';

class LeaveFormPage extends StatefulWidget {
  const LeaveFormPage({super.key});

  @override
  State<LeaveFormPage> createState() => _LeaveFormPageState();
}

class _LeaveFormPageState extends State<LeaveFormPage> {
  final descC = TextEditingController();

  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;

  final _formKey = GlobalKey<FormState>();

  /// Jenis izin (dummy / nanti ambil dari backend)
  final List<String> leaveTypes = [
    "Sakit",
    "Izin",
    "Cuti Tahunan",
    "Cuti Khusus",
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Izin")),

      body: BlocConsumer<LeaveCubit, LeaveState>(
        listener: (context, state) {
          if (state.isSubmitting) {
            LoadingOverlay.showOverlay(context);
          } else {
            LoadingOverlay.hideOverlay();
          }

          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pengajuan izin berhasil dikirim")),
            );
            Navigator.pop(context);
          }

          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },

        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // =============================
                  // Dropdown Jenis Izin
                  // =============================
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: "Jenis Izin",
                      border: OutlineInputBorder(),
                    ),
                    items: leaveTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedType = value),
                    validator: (value) =>
                        value == null ? "Pilih jenis izin" : null,
                  ),

                  const SizedBox(height: 16),

                  // =============================
                  // Deskripsi Izin
                  // =============================
                  TextFormField(
                    controller: descC,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Keterangan",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Isi keterangan"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // =============================
                  // Date Range Picker
                  // =============================
                  ElevatedButton(
                    onPressed: () async {
                      final today = DateTime.now();
                      final result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(today.year - 1),
                        lastDate: DateTime(today.year + 1),
                      );

                      if (result != null) {
                        setState(() {
                          startDate = result.start;
                          endDate = result.end;
                        });
                      }
                    },
                    child: Text(
                      startDate == null
                          ? "Pilih Tanggal Izin"
                          : "Dipilih: ${startDate!.toLocal().toString().split(' ')[0]} - ${endDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =============================
                  // BUTTON AJUKAN
                  // =============================
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Pilih rentang tanggal"),
                          ),
                        );
                        return;
                      }

                      context.read<LeaveCubit>().submitLeave(
                        employeeId: auth.employeeId!,
                        type: selectedType!,
                        description: descC.text.trim(),
                        start: startDate!,
                        end: endDate!,
                      );
                    },
                    child: const Text("Ajukan Izin"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
