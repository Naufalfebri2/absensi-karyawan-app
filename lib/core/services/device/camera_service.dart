import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// ===============================
/// CAMERA SERVICE
/// ===============================
/// Tanggung jawab:
/// - Mengambil foto selfie (kamera depan)
/// - Abstraksi layer device (UI tidak tahu detail camera)
/// - Dipakai oleh Check-In & Check-Out
///
/// NOTE:
/// - Face detection BELUM di sini (tahap berikutnya)
/// ===============================

class CameraService {
  CameraService();

  CameraController? _controller;
  List<CameraDescription>? _cameras;

  /// ===============================
  /// INIT CAMERA
  /// ===============================
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();

      // Prioritaskan kamera depan
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
    } catch (e) {
      debugPrint('Camera init error: $e');
      rethrow;
    }
  }

  /// ===============================
  /// GET CONTROLLER
  /// ===============================
  CameraController get controller {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera belum diinisialisasi');
    }
    return _controller!;
  }

  /// ===============================
  /// TAKE SELFIE
  /// ===============================
  Future<File> takeSelfie() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw Exception('Camera belum siap');
      }

      if (_controller!.value.isTakingPicture) {
        throw Exception('Camera sedang mengambil gambar');
      }

      final XFile picture = await _controller!.takePicture();

      return File(picture.path);
    } catch (e) {
      debugPrint('Take selfie error: $e');
      rethrow;
    }
  }

  /// ===============================
  /// DISPOSE CAMERA
  /// ===============================
  Future<void> dispose() async {
    try {
      await _controller?.dispose();
      _controller = null;
    } catch (e) {
      debugPrint('Camera dispose error: $e');
    }
  }
}
