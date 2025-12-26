import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// ===============================
/// FACE DETECTION SERVICE (ML KIT)
/// ===============================
/// - Deteksi apakah foto mengandung wajah
/// - Dipakai setelah selfie diambil
/// - BUKAN face recognition
/// ===============================

class FaceDetectionService {
  FaceDetectionService()
    : _detector = FaceDetector(
        options: FaceDetectorOptions(
          enableLandmarks: false,
          enableContours: false,
          enableClassification: false,
          performanceMode: FaceDetectorMode.fast,
        ),
      );

  final FaceDetector _detector;

  /// ===============================
  /// CHECK FACE EXISTS
  /// ===============================
  Future<bool> hasFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    final List<Face> faces = await _detector.processImage(inputImage);

    return faces.isNotEmpty;
  }

  /// ===============================
  /// DISPOSE
  /// ===============================
  Future<void> dispose() async {
    await _detector.close();
  }
}
