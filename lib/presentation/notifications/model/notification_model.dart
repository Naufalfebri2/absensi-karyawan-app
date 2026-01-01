// import 'package:equatable/equatable.dart';

// /// =======================================================
// /// NOTIFICATION MODEL
// /// =======================================================
// /// - Dipakai untuk data notifikasi real-time (WebSocket)
// /// - BUKAN dari REST API
// /// - Immutable & Equatable (aman untuk BLoC)
// /// =======================================================
// class NotificationModel extends Equatable {
//   final String id;
//   final String type;
//   final String title;
//   final String message;
//   final DateTime time;
//   final bool isRead;

//   const NotificationModel({
//     required this.id,
//     required this.type,
//     required this.title,
//     required this.message,
//     required this.time,
//     this.isRead = false,
//   });

//   // =======================================================
//   // FROM JSON (WEBSOCKET PAYLOAD)
//   // =======================================================
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['id']?.toString() ?? '',
//       type: json['type']?.toString() ?? 'general',
//       title: json['title']?.toString() ?? '',
//       message: json['message']?.toString() ?? '',
//       time: _parseTime(json['time']),
//       isRead: json['is_read'] == true,
//     );
//   }

//   // =======================================================
//   // COPY WITH
//   // =======================================================
//   NotificationModel copyWith({
//     String? id,
//     String? type,
//     String? title,
//     String? message,
//     DateTime? time,
//     bool? isRead,
//   }) {
//     return NotificationModel(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       title: title ?? this.title,
//       message: message ?? this.message,
//       time: time ?? this.time,
//       isRead: isRead ?? this.isRead,
//     );
//   }

//   // =======================================================
//   // HELPER: PARSE TIME SAFELY
//   // =======================================================
//   static DateTime _parseTime(dynamic value) {
//     if (value == null) return DateTime.now();

//     if (value is DateTime) return value;

//     if (value is String) {
//       try {
//         return DateTime.parse(value);
//       } catch (_) {
//         return DateTime.now();
//       }
//     }

//     return DateTime.now();
//   }

//   // =======================================================
//   // EQUATABLE
//   // =======================================================
//   @override
//   List<Object?> get props => [id, type, title, message, time, isRead];
// }
