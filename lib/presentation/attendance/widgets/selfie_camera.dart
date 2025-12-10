import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SelfieCamera extends StatefulWidget {
  final Function(String path) onCaptured;

  /// Dipakai seperti:
  /// SelfieCamera(onCaptured: (path) { ... });
  const SelfieCamera({super.key, required this.onCaptured});

  @override
  State<SelfieCamera> createState() => _SelfieCameraState();
}

class _SelfieCameraState extends State<SelfieCamera> {
  CameraController? _controller;
  XFile? _capturedFile;

  bool _isInitializing = true;
  bool _isTakingPicture = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = "Kamera tidak tersedia di perangkat ini.";
          _isInitializing = false;
        });
        return;
      }

      // Pakai kamera depan kalau ada, kalau tidak pakai kamera pertama
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!context.mounted) return;
      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (e) {
      if (!context.mounted) return;
      setState(() {
        _errorMessage = "Gagal mengakses kamera: $e";
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);

    try {
      final picture = await _controller!.takePicture();
      if (!context.mounted) return;

      setState(() {
        _capturedFile = picture;
      });

      widget.onCaptured(picture.path);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil foto: $e")));
    } finally {
      if (context.mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // State: masih init
    if (_isInitializing) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // State: error
    if (_errorMessage != null) {
      return SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 40),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _initCamera,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba lagi"),
            ),
          ],
        ),
      );
    }

    // State: kamera siap
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: _capturedFile == null
                ? (_controller != null && _controller!.value.isInitialized
                      ? CameraPreview(_controller!)
                      : const Center(child: Text("Kamera tidak siap")))
                : Image.file(File(_capturedFile!.path), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: _isTakingPicture
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.camera_alt),
          label: Text(_capturedFile == null ? "Ambil Selfie" : "Ambil Ulang"),
          onPressed: _isTakingPicture ? null : _takePicture,
        ),
      ],
    );
  }
}
