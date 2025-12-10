part of 'attendance_history_cubit.dart';

abstract class AttendanceHistoryState {}

class AttendanceHistoryInitial extends AttendanceHistoryState {}

class AttendanceHistoryLoading extends AttendanceHistoryState {}

class AttendanceHistorySuccess extends AttendanceHistoryState {
  final List<AttendanceEntity> list;
  AttendanceHistorySuccess(this.list);
}

class AttendanceHistoryError extends AttendanceHistoryState {
  final String message;
  AttendanceHistoryError(this.message);
}
