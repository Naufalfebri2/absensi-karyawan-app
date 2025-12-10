part of 'checkin_cubit.dart';

abstract class CheckinState {}

class CheckinInitial extends CheckinState {}

class CheckinLoading extends CheckinState {}

class CheckinSuccess extends CheckinState {
  final AttendanceEntity data;
  CheckinSuccess(this.data);
}

class CheckinError extends CheckinState {
  final String message;
  CheckinError(this.message);
}
