import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_entity.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {
  const CheckInInitial();
}

class CheckInLoading extends CheckInState {
  const CheckInLoading();
}

class CheckInSuccess extends CheckInState {
  final AttendanceStatus status;
  final DateTime checkInTime;

  const CheckInSuccess({required this.status, required this.checkInTime});

  @override
  List<Object?> get props => [status, checkInTime];
}

class CheckInFailure extends CheckInState {
  final String message;

  const CheckInFailure(this.message);

  @override
  List<Object?> get props => [message];
}
