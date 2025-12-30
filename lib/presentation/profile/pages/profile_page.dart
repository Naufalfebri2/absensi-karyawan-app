import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/services/device/gallery_picker.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ===============================
  // FORM KEY
  // ===============================
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController(); // ✅ NEW
  final TextEditingController rollC = TextEditingController();
  final TextEditingController birthC = TextEditingController();
  final TextEditingController aadhaarC = TextEditingController();

  final GalleryPicker _galleryPicker = GalleryPicker();

  DateTime? selectedDate;

  /// 🔥 OPTIMISTIC AVATAR
  File? _optimisticAvatar;

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose(); // ✅ NEW
    rollC.dispose();
    birthC.dispose();
    aadhaarC.dispose();
    super.dispose();
  }

  // ===============================
  // DATE PICKER
  // ===============================
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthC.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  // ===============================
  // PICK & UPDATE AVATAR
  // ===============================
  Future<void> _changeAvatar() async {
    final File? image = await _galleryPicker.pickImage();
    if (image == null) return;
    if (!mounted) return;

    context.read<ProfileCubit>().updateAvatar(image);
  }

  // ===============================
  // LOGOUT
  // ===============================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthCubit>().logout();

              if (!mounted) return;
              context.go('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ===============================
  // BOTTOM NAV
  // ===============================
  int _getIndexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/leave')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    if (_getIndexFromLocation(context) == index) return;

    final router = GoRouter.of(context);

    switch (index) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/calendar');
        break;
      case 2:
        router.go('/attendance');
        break;
      case 3:
        router.go('/leave');
        break;
      case 4:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
          final user = state is ProfileLoaded
              ? state.user
              : (state as ProfileUpdateSuccess).user;

          nameC.text = user.name;
          emailC.text = user.email;
          phoneC.text = user.phoneNumber ?? ''; // ✅ NEW
          rollC.text = user.position;
          aadhaarC.text = user.department;

          _optimisticAvatar = null;
        }

        if (state is ProfileAvatarOptimistic) {
          setState(() {
            _optimisticAvatar = state.avatarFile;
          });
        }

        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile berhasil diperbarui')),
          );
        }

        if (state is ProfileError) {
          _optimisticAvatar = null;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final bool isLoading = state is ProfileLoading;

              return Stack(
                children: [
                  Column(
                    children: [
                      _buildHeader(),
                      Expanded(child: _buildContent(context, state, isLoading)),
                    ],
                  ),
                  if (isLoading) _buildLoadingOverlay(),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ===============================
  // UI
  // ===============================
  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileState state,
    bool isLoading,
  ) {
    final avatarUrl = state is ProfileLoaded
        ? state.user.avatarUrl
        : state is ProfileUpdateSuccess
        ? state.user.avatarUrl
        : null;

    ImageProvider avatarImage;
    if (_optimisticAvatar != null) {
      avatarImage = FileImage(_optimisticAvatar!);
    } else if (avatarUrl != null) {
      avatarImage = NetworkImage(avatarUrl);
    } else {
      avatarImage = const AssetImage("assets/images/logo.png");
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),

            // AVATAR
            Opacity(
              opacity: isLoading ? 0.6 : 1,
              child: IgnorePointer(
                ignoring: isLoading,
                child: GestureDetector(
                  onTap: _changeAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(radius: 65, backgroundImage: avatarImage),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            fieldLabel("Name"),
            buildField(nameC, validator: _requiredValidator),

            const SizedBox(height: 16),

            fieldLabel("Email"),
            buildField(
              emailC,
              keyboardType: TextInputType.emailAddress,
              suffix: const Icon(Icons.email_outlined),
              validator: _emailValidator,
            ),

            const SizedBox(height: 16),

            fieldLabel("Phone Number"),
            buildField(
              phoneC,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Phone Number wajib diisi';
                if (v.length < 9) return 'Phone Number terlalu pendek';
                return null;
              },
            ),

            const SizedBox(height: 16),

            fieldLabel("Position"),
            buildField(rollC, validator: _requiredValidator),

            const SizedBox(height: 16),

            fieldLabel("Date of Birth"),
            GestureDetector(
              onTap: pickDate,
              child: AbsorbPointer(child: buildField(birthC)),
            ),

            const SizedBox(height: 16),

            fieldLabel("Department"),
            buildField(aadhaarC, validator: _requiredValidator),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) return;

                        context.read<ProfileCubit>().updateProfile(
                          name: nameC.text,
                          email: emailC.text,
                          position: rollC.text,
                          department: aadhaarC.text,
                          // phoneNumber → nanti ikut API
                        );
                      },
                child: const Text("Save changes"),
              ),
            ),

            const SizedBox(height: 24),

            OutlinedButton(
              onPressed: isLoading ? null : _showLogoutDialog,
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndexFromLocation(context),
      onTap: (index) => _onNavTap(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: "Attendance",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Leave"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Widget fieldLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget buildField(
    TextEditingController controller, {
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ===============================
  // VALIDATORS
  // ===============================
  String? _requiredValidator(String? v) =>
      v == null || v.trim().isEmpty ? 'Field ini wajib diisi' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }
}
