// lib/presentation/admin/pages/manage_users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_users_cubit.dart';
import '../bloc/manage_users_state.dart';
import '../../../domain/entities/user_entity.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Pastikan di cubit kamu ada method seperti ini
              // Kalau namanya beda, tinggal ganti
              context.read<ManageUsersCubit>().loadUsers();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ManageUsersCubit, ManageUsersState>(
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
            final List<UserEntity> users = state.users;

            if (users.isEmpty) {
              return const Center(child: Text('Belum ada data karyawan.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(user.fullName),
                    subtitle: Text('${user.email} • ${user.role}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showUserFormDialog(context, user: user);
                            break;
                          case 'delete':
                            _confirmDeleteUser(context, user.id);
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

          // State awal / unknown
          return const Center(
            child: Text('Tekan tombol refresh untuk memuat data.'),
          );
        },
      ),
    );
  }

  void _showUserFormDialog(BuildContext context, {UserEntity? user}) {
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final roleController = TextEditingController(text: user?.role ?? '');

    showDialog(
      context: context,
      builder: (context) {
        final isEdit = user != null;

        return AlertDialog(
          title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role (Employee/HR/Admin)',
                  ),
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
                // Validasi sederhana
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    roleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama, Email, dan Role wajib diisi'),
                    ),
                  );
                  return;
                }

                final newUser = UserEntity(
                  id: user?.id ?? 0, // id akan diisi backend saat create
                  token:
                      user?.token ??
                      '', // token might not be needed for admin operations
                  fullName: nameController.text,
                  email: emailController.text,
                  role: roleController.text,
                  employeeId:
                      user?.employeeId ??
                      0, // employeeId might be set by backend
                  photoUrl: user?.photoUrl,
                );

                final cubit = context.read<ManageUsersCubit>();

                if (isEdit) {
                  cubit.updateUser(newUser);
                } else {
                  cubit.createUser(newUser);
                }

                Navigator.pop(context);
              },
              child: Text(user != null ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteUser(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Karyawan'),
        content: const Text(
          'Yakin ingin menghapus karyawan ini? Tindakan tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ManageUsersCubit>().deleteUser(userId);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
