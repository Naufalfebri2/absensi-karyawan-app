// lib/presentation/admin/pages/manage_department_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_department_cubit.dart';
import '../bloc/manage_department_state.dart';
import '../../../domain/entities/department_entity.dart';

class ManageDepartmentPage extends StatelessWidget {
  const ManageDepartmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Departemen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ManageDepartmentCubit>().loadDepartments();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDepartmentFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ManageDepartmentCubit, ManageDepartmentState>(
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
            final departments = state.departments;

            if (departments.isEmpty) {
              return const Center(child: Text('Belum ada departemen.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: departments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final dept = departments[index];

                return Card(
                  child: ListTile(
                    title: Text(dept.name),
                    subtitle:
                        dept.description != null &&
                            dept.description!.trim().isNotEmpty
                        ? Text(dept.description!)
                        : const Text(''),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showDepartmentFormDialog(
                              context,
                              department: dept,
                            );
                            break;
                          case 'delete':
                            _confirmDeleteDepartment(context, dept.id);
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
            child: Text('Tekan tombol refresh untuk memuat departemen.'),
          );
        },
      ),
    );
  }

  void _showDepartmentFormDialog(
    BuildContext context, {
    DepartmentEntity? department,
  }) {
    final nameController = TextEditingController(text: department?.name ?? '');
    final descController = TextEditingController(
      text: department?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        final isEdit = department != null;

        return AlertDialog(
          title: Text(isEdit ? 'Edit Departemen' : 'Tambah Departemen'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Departemen',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (opsional)',
                  ),
                  maxLines: 3,
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
                    const SnackBar(
                      content: Text('Nama departemen wajib diisi'),
                    ),
                  );
                  return;
                }

                final newDept = DepartmentEntity(
                  id: department?.id ?? 0,
                  name: nameController.text,
                  description: descController.text.isEmpty
                      ? null
                      : descController.text,
                );

                final cubit = context.read<ManageDepartmentCubit>();

                if (isEdit) {
                  cubit.updateDepartment(newDept);
                } else {
                  cubit.createDepartment(newDept);
                }

                Navigator.pop(context);
              },
              child: Text(department != null ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteDepartment(BuildContext context, int deptId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Departemen'),
        content: const Text('Yakin ingin menghapus departemen ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ManageDepartmentCubit>().deleteDepartment(deptId);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
