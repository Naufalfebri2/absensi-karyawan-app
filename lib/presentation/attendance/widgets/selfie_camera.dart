import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/services/device/camera_service.dart';

class SelfieCameraPage extends StatefulWidget {
  const SelfieCameraPage({super.key});

  @override
  State<SelfieCameraPage> createState() => _SelfieCameraPageState();
}

class _SelfieCameraPageState extends State<SelfieCameraPage> {
  final CameraService _cameraService = CameraService();
  late final FaceDetector _faceDetector;

  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // 🔥 WAJIB enableClassification untuk eye-open
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableClassification: true, // 👀 EYE OPEN
        enableLandmarks: false,
        enableContours: false,
      ),
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _cameraService.initialize();
      if (!mounted) return;

      setState(() => _isInitialized = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Gagal mengakses kamera');
    }
  }

  // ===============================
  // VALIDASI WAJAH (ANTI FAKE)
  // ===============================
  bool _isFaceValid(Face face) {
    // 👀 EYE OPEN
    final leftEye = face.leftEyeOpenProbability ?? 0;
    final rightEye = face.rightEyeOpenProbability ?? 0;
    final eyesOpen = leftEye >= 0.5 && rightEye >= 0.5;

    // 🧭 HEAD POSE
    final yaw = face.headEulerAngleY ?? 0; // kiri-kanan
    final pitch = face.headEulerAngleX ?? 0; // atas-bawah
    final facingCamera = yaw.abs() <= 15 && pitch.abs() <= 15;

    return eyesOpen && facingCamera;
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _isCapturing = false;
      _errorMessage = message;
    });
  }

  // ===============================
  // CAPTURE + FACE VALIDATION
  // ===============================
  Future<void> _capture() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
      _errorMessage = null;
    });

    try {
      final File selfie = await _cameraService.takeSelfie();

      final inputImage = InputImage.fromFile(selfie);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _setError(
          'Wajah tidak terdeteksi.\nPastikan wajah berada di dalam frame.',
        );
        return;
      }

      if (faces.length > 1) {
        _setError('Terdeteksi lebih dari satu wajah.');
        return;
      }

      if (!_isFaceValid(faces.first)) {
        _setError('Pastikan mata terbuka dan wajah menghadap kamera.');
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop(selfie);
    } catch (_) {
      _setError('Gagal mengambil foto');
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF624731);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: brown,
        foregroundColor: Colors.white,
        title: const Text('Ambil Foto Selfie'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: _errorMessage != null
          ? _buildError()
          : !_isInitialized
          ? _buildLoading()
          : _buildCameraPreview(),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 🔥 MIRROR PREVIEW
        Positioned.fill(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.141592653589793),
            child: CameraPreview(_cameraService.controller),
          ),
        ),

        // Overlay wajah
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
            ),
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
        ),

        // Instruction
        const Positioned(
          bottom: 120,
          child: Column(
            children: [
              Text(
                'Posisikan wajah di tengah',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Pastikan mata terbuka & menghadap kamera',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),

        // Capture button
        Positioned(
          bottom: 32,
          child: GestureDetector(
            onTap: _isCapturing ? null : _capture,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white,
              ),
              child: _isCapturing
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.brown,
                      ),
                    )
                  : const Icon(Icons.camera_alt, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() => _errorMessage = null);
              _initCamera();
            },
            child: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
