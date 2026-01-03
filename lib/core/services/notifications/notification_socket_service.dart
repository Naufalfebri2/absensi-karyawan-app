import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

/// =======================================================
/// NOTIFICATION SOCKET SERVICE (PURE WEBSOCKET)
/// =======================================================
/// - WebSocket murni (NO Laravel Echo / NO Pusher)
/// - Token-based auth (query param / header fallback)
/// - Auto reconnect (safe)
/// - Stream-based (Cubit friendly)
/// - Compatible with Flutter SDK 3.9+
/// =======================================================
class NotificationSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  StreamController<Map<String, dynamic>>? _controller;

  bool _isConnected = false;
  bool _isConnecting = false;
  bool _manuallyDisconnected = false;

  // ===============================
  // BACKEND CONFIG
  // ===============================
  /// Contoh:
  /// ws://10.51.215.119:8000/ws/notifications
  static const String _socketUrl =
      'ws://10.51.215.119:8000/employee/1';

  // ===============================
  // CONNECT
  // ===============================
  Stream<Map<String, dynamic>> connect({required String token}) {
    // Reuse stream jika sudah connect
    if (_isConnected && _controller != null && !_controller!.isClosed) {
      return _controller!.stream;
    }

    _manuallyDisconnected = false;
    _controller ??= StreamController<Map<String, dynamic>>.broadcast();

    _openSocket(token);

    return _controller!.stream;
  }

  // ===============================
  // OPEN SOCKET
  // ===============================
  void _openSocket(String token) {
    if (_isConnecting || _manuallyDisconnected) return;
    _isConnecting = true;

    try {
      final uri = Uri.parse('$_socketUrl?token=$token');

      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        (event) {
          _isConnected = true;
          _isConnecting = false;

          // Backend biasanya kirim JSON string
          if (event is String) {
            try {
              final decoded = jsonDecode(event);
              if (decoded is Map<String, dynamic>) {
                _controller?.add(decoded);
              }
            } catch (_) {
              // ignore invalid json
            }
          }
        },
        onError: (_) {
          _handleDisconnect(token);
        },
        onDone: () {
          _handleDisconnect(token);
        },
        cancelOnError: true,
      );
    } catch (_) {
      _handleDisconnect(token);
    }
  }

  // ===============================
  // HANDLE DISCONNECT
  // ===============================
  void _handleDisconnect(String token) {
    _cleanup();

    if (_manuallyDisconnected) return;

    // Auto reconnect (delay aman)
    Future.delayed(const Duration(seconds: 3), () {
      if (!_manuallyDisconnected) {
        _openSocket(token);
      }
    });
  }

  // ===============================
  // CLEANUP
  // ===============================
  void _cleanup() {
    _isConnected = false;
    _isConnecting = false;

    _subscription?.cancel();
    _subscription = null;

    try {
      _channel?.sink.close(ws_status.goingAway);
    } catch (_) {}

    _channel = null;
  }

  // ===============================
  // SEND MESSAGE (OPTIONAL)
  // ===============================
  void send(Map<String, dynamic> payload) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode(payload));
      } catch (_) {
        // ignore
      }
    }
  }

  // ===============================
  // DISCONNECT (MANUAL)
  // ===============================
  void disconnect() {
    _manuallyDisconnected = true;
    _cleanup();

    _controller?.close();
    _controller = null;
  }

  // ===============================
  // STATUS
  // ===============================
  bool get isConnected => _isConnected;
}
