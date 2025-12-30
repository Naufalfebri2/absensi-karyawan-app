import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// ===============================
/// GALLERY PICKER SERVICE
/// ===============================
/// - Pick image from device gallery
/// - No native crop (circle handled by UI)
/// - Stable for Flutter 3.x
/// - No camera access
/// ===============================
class GalleryPicker {
  GalleryPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<File?> pickImage({int imageQuality = 85, double maxSize = 512}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxSize,
        maxHeight: maxSize,
      );

      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (_) {
      return null;
    }
  }
}
