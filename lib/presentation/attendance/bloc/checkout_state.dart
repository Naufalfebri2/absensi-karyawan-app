import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_entity.dart';

abstract class CheckOutState extends Equatable {
  const CheckOutState();

  @override
  List<Object?> get props => [];
}

class CheckOutInitial extends CheckOutState {
  const CheckOutInitial();
}

class CheckOutLoading extends CheckOutState {
  const CheckOutLoading();
}

class CheckOutSuccess extends CheckOutState {
  final AttendanceStatus status;
  final DateTime checkOutTime;

  const CheckOutSuccess({required this.status, required this.checkOutTime});

  @override
  List<Object?> get props => [status, checkOutTime];
}

class CheckOutFailure extends CheckOutState {
  final String message;

  const CheckOutFailure(this.message);

  @override
  List<Object?> get props => [message];
}
