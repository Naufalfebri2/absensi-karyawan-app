import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/services/device/gallery_picker.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

enum ProfileViewMode { main, edit }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileViewMode _mode = ProfileViewMode.main;

  // ✅ STATE HARUS DI SINI
  bool _pushNotificationEnabled = false;
  bool _appUpdateEnabled = false;

  // ===============================
  // FORM
  // ===============================
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController rollC = TextEditingController();
  final TextEditingController birthC = TextEditingController();
  final TextEditingController aadhaarC = TextEditingController();

  final GalleryPicker _galleryPicker = GalleryPicker();
  File? _optimisticAvatar;

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    rollC.dispose();
    birthC.dispose();
    aadhaarC.dispose();
    super.dispose();
  }

  // ===============================
  // HEADER
  // ===============================
  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // ⬅️ BACK + LOGO (TETAP ADA)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.go('/home');
                },
              ),
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
            ],
          ),

          // TITLE
          Expanded(
            child: Center(
              child: Text(
                "Profile",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // NOTIFICATION ICON
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  // ===============================
  // MAIN PROFILE VIEW (FINAL)
  // ===============================
  Widget _buildProfileMain() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 48,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(height: 12),
          const Text(
            "John Smith",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _profileCard(
            title: "Account Setting",
            children: [
              _menuItem(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () => setState(() => _mode = ProfileViewMode.edit),
              ),
              _menuItem(icon: Icons.lock_outline, title: "Security & Privacy"),
            ],
          ),

          const SizedBox(height: 16),

          _profileCard(
            title: "Notification Setting",
            children: [
              _switchItem(
                title: "Push Notification",
                value: _pushNotificationEnabled,
                onChanged: (val) =>
                    setState(() => _pushNotificationEnabled = val),
              ),
              _switchItem(
                title: "App Update",
                value: _appUpdateEnabled,
                onChanged: (val) => setState(() => _appUpdateEnabled = val),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _profileCard(
            title: "More",
            children: [
              _menuItem(icon: Icons.help_outline, title: "Help"),
              _menuItem(icon: Icons.info_outline, title: "About App"),
              _menuItem(
                icon: Icons.logout,
                title: "Log Out",
                color: Colors.red,
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  // ===============================
  // EDIT PROFILE
  // ===============================
  Widget _buildEditProfile(bool isLoading) {
    final ImageProvider avatarImage = _optimisticAvatar != null
        ? FileImage(_optimisticAvatar!)
        : const AssetImage("assets/images/logo.png");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: isLoading ? null : _changeAvatar,
              child: CircleAvatar(radius: 65, backgroundImage: avatarImage),
            ),
            const SizedBox(height: 24),
            _field("Name", nameC),
            _field("Email", emailC),
            _field("Phone Number", phoneC),
            _field("Position", rollC),
            _field("Date of Birth", birthC),
            _field("Department", aadhaarC),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // coklat
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<ProfileCubit>().updateProfile(
                          name: nameC.text,
                          email: emailC.text,
                          phoneNumber: phoneC.text,
                          position: rollC.text,
                          department: aadhaarC.text,
                        );
                      },
                child: const Text(
                  "Save changes",
                  style: TextStyle(
                    color: Colors.white, // ✅ FIX DI SINI
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // BUILD
  // ===============================
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _mode == ProfileViewMode.main
                      ? _buildProfileMain()
                      : _buildEditProfile(state is ProfileLoading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _switchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.primary,
      activeColor: Colors.white,
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(controller: c),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go('/login');
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _changeAvatar() async {
    final file = await _galleryPicker.pickImage();
    if (file != null) setState(() => _optimisticAvatar = file);
  }
}
