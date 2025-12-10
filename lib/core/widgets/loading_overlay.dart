import 'package:flutter/material.dart';

/// ===============================================
/// LOADING OVERLAY (PROFESSIONAL STYLE)
///
/// Cara pakai:
/// LoadingOverlay.show(context);
/// LoadingOverlay.hide();
///
/// Bisa dipakai di semua halaman.
/// ===============================================
class LoadingOverlay {
  static final LoadingOverlay _instance = LoadingOverlay._internal();
  factory LoadingOverlay() => _instance;

  LoadingOverlay._internal();

  OverlayEntry? _overlayEntry;

  bool get isShowing => _overlayEntry != null;

  /// TAMPILKAN OVERLAY
  void show(BuildContext context, {String? message}) {
    if (isShowing) return; // prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Background blur + dark overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.4),
          ),

          // Center loading indicator
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    message ?? "Loading...",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Insert overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// HILANGKAN OVERLAY
  void hide() {
    if (!isShowing) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// STATIC HELPERS (BIAR SIMPLE)
  static void showOverlay(BuildContext context, {String? message}) {
    LoadingOverlay().show(context, message: message);
  }

  static void hideOverlay() {
    LoadingOverlay().hide();
  }
}
