import '../../repositories/attendance_repository.dart';
import '../../entities/attendance_entity.dart';

class CheckOut {
  final AttendanceRepository repository;

  CheckOut(this.repository);

  Future<AttendanceEntity> call() {
    return repository.checkOut();
  }
}
