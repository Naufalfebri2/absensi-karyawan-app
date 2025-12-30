import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../../../config/theme/app_colors.dart';

class ProfileLogo extends StatefulWidget {
  final String? imageUrl;

  const ProfileLogo({super.key, this.imageUrl});

  @override
  State<ProfileLogo> createState() => _ProfileLogoState();
}

class _ProfileLogoState extends State<ProfileLogo> {
  final ImagePicker _picker = ImagePicker();
  File? _previewImage;
  bool _isUploading = false;

  // ===============================
  // PICK IMAGE (CAMERA / GALLERY)
  // ===============================
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (!mounted) return;

      if (picked != null) {
        final tempFile = File(picked.path);

        setState(() {
          _previewImage = tempFile;
          _isUploading = true;
        });

        // 🔥 Upload langsung (tanpa simpan file)
        context.read<ProfileCubit>().updateAvatar(tempFile);
      }
    } catch (_) {
      if (!mounted) return;
      _showError('Gagal memilih gambar');
    }
  }

  // ===============================
  // BOTTOM SHEET PICKER
  // ===============================
  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ===============================
  // ERROR SNACKBAR
  // ===============================
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          setState(() {
            _isUploading = false;
            _previewImage = null;
          });
        }

        if (state is ProfileError) {
          setState(() {
            _isUploading = false;
            _previewImage = null;
          });

          _showError(state.message);
        }
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildAvatar(),
          _buildEditButton(),
          if (_isUploading) _buildLoading(),
        ],
      ),
    );
  }

  // ===============================
  // AVATAR
  // ===============================
  Widget _buildAvatar() {
    ImageProvider image;

    if (_previewImage != null) {
      image = FileImage(_previewImage!);
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      image = NetworkImage(widget.imageUrl!);
    } else {
      image = const AssetImage('assets/images/logo.png');
    }

    return CircleAvatar(
      radius: 65,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: image,
    );
  }

  // ===============================
  // EDIT BUTTON
  // ===============================
  Widget _buildEditButton() {
    return Positioned(
      bottom: 4,
      right: 4,
      child: GestureDetector(
        onTap: _isUploading ? null : _showPicker,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  // ===============================
  // LOADING OVERLAY
  // ===============================
  Widget _buildLoading() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      ),
    );
  }
}
