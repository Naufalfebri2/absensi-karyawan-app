// lib/presentation/admin/pages/manage_shift_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_shift_cubit.dart';
import '../bloc/manage_shift_state.dart';
import '../../../domain/entities/shift_entity.dart';

class ManageShiftPage extends StatelessWidget {
  const ManageShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Shift'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ManageShiftCubit>().loadShifts();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showShiftFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ManageShiftCubit, ManageShiftState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!state.isLoading && state.errorMessage == null) {
            final shifts = state.shifts;

            if (shifts.isEmpty) {
              return const Center(child: Text('Belum ada data shift.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: shifts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final shift = shifts[index];

                return Card(
                  child: ListTile(
                    title: Text(shift.name),
                    subtitle: Text(
                      '${shift.startTime} - ${shift.endTime}\n'
                      'Toleransi terlambat: ${shift.toleranceLate} menit\n'
                      'Hari kerja: ${shift.workingDays}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showShiftFormDialog(context, shift: shift);
                            break;
                          case 'delete':
                            _confirmDeleteShift(context, shift.id);
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Hapus')),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Tekan tombol refresh untuk memuat shift.'),
          );
        },
      ),
    );
  }

  void _showShiftFormDialog(BuildContext context, {ShiftEntity? shift}) {
    final nameController = TextEditingController(text: shift?.name ?? '');
    final startController = TextEditingController(
      text: shift?.startTime ?? '08:00:00',
    );
    final endController = TextEditingController(
      text: shift?.endTime ?? '17:00:00',
    );
    final toleranceController = TextEditingController(
      text: shift?.toleranceLate.toString() ?? '15',
    );
    final workingDaysController = TextEditingController(
      text: shift?.workingDays ?? 'Mon-Fri',
    );

    bool isActive = shift?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        final isEdit = shift != null;

        return AlertDialog(
          title: Text(isEdit ? 'Edit Shift' : 'Tambah Shift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Shift (Pagi/Malam)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(
                    labelText: 'Jam Mulai (HH:mm:ss)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(
                    labelText: 'Jam Selesai (HH:mm:ss)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: toleranceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Toleransi Terlambat (menit)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: workingDaysController,
                  decoration: const InputDecoration(
                    labelText: 'Hari Kerja (contoh: Mon-Fri)',
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Aktif'),
                  value: isActive,
                  onChanged: (val) {
                    isActive = val;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama shift wajib diisi')),
                  );
                  return;
                }

                final tolerance = int.tryParse(toleranceController.text) ?? 0;

                final newShift = ShiftEntity(
                  id: shift?.id ?? 0,
                  name: nameController.text,
                  startTime: startController.text,
                  endTime: endController.text,
                  toleranceLate: tolerance,
                  workingDays: workingDaysController.text,
                  isActive: isActive,
                );

                final cubit = context.read<ManageShiftCubit>();

                if (isEdit) {
                  cubit.updateShift(newShift);
                } else {
                  cubit.createShift(newShift);
                }

                Navigator.pop(context);
              },
              child: Text(shift != null ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteShift(BuildContext context, int shiftId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Shift'),
        content: const Text('Yakin ingin menghapus shift ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ManageShiftCubit>().deleteShift(shiftId);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
