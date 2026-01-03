import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

/// =======================================================
/// NOTIFICATION SOCKET SERVICE
/// =======================================================
/// - WebSocket real-time notification
/// - Auto reconnect
/// - Token-based auth (query param)
/// - Safe close & dispose
/// - Clean (NO Dio / NO REST)
/// =======================================================
class NotificationSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool _manuallyDisconnected = false;

  /// GANTI SESUAI BACKEND KAMU
  static const String _socketUrl = 'ws://202.10.35.18:8002';

  // =======================================================
  // CONNECT
  // =======================================================
  Stream<Map<String, dynamic>> connect({required String token}) {
    if (_isConnected && _controller != null) {
      return _controller!.stream;
    }

    _manuallyDisconnected = false;
    _controller = StreamController<Map<String, dynamic>>.broadcast();

    _openSocket(token);

    return _controller!.stream;
  }

  // =======================================================
  // INTERNAL: OPEN SOCKET
  // =======================================================
  void _openSocket(String token) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$_socketUrl?token=$token'),
      );

      _isConnected = true;

      _subscription = _channel!.stream.listen(
        (event) {
          try {
            final data = jsonDecode(event);
            if (data is Map<String, dynamic>) {
              _controller?.add(data);
            }
          } catch (_) {
            // ignore malformed message
          }
        },
        onError: (_) {
          _handleDisconnect(token);
        },
        onDone: () {
          _handleDisconnect(token);
        },
      );
    } catch (_) {
      _handleDisconnect(token);
    }
  }

  // =======================================================
  // INTERNAL: HANDLE DISCONNECT & RECONNECT
  // =======================================================
  void _handleDisconnect(String token) {
    _isConnected = false;

    if (_manuallyDisconnected) return;

    // auto reconnect after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (!_manuallyDisconnected) {
        _openSocket(token);
      }
    });
  }

  // =======================================================
  // SEND MESSAGE (OPTIONAL)
  // =======================================================
  void send(Map<String, dynamic> payload) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(payload));
    }
  }

  // =======================================================
  // DISCONNECT (MANUAL)
  // =======================================================
  void disconnect() {
    _manuallyDisconnected = true;
    _isConnected = false;

    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close(ws_status.goingAway);
    _channel = null;

    _controller?.close();
    _controller = null;
  }

  // =======================================================
  // STATUS
  // =======================================================
  bool get isConnected => _isConnected;
}
