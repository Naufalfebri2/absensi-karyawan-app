import 'package:absensi_karyawan_app/domain/entities/leave_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/leave_repo.dart';

class SubmitLeave {
  final LeaveRepository repository;

  SubmitLeave(this.repository);

  Future<LeaveEntity> call(LeaveEntity leave) {
    return repository.submitLeave(leave);
  }
}
