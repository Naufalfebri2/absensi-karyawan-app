import 'package:absensi_karyawan_app/domain/entities/shift_entity.dart';
import 'package:absensi_karyawan_app/domain/repositories/shift_repo.dart';

class UpdateShift {
  final ShiftRepository repository;

  UpdateShift(this.repository);

  Future<ShiftEntity> call(ShiftEntity shift) {
    return repository.updateShift(shift);
  }
}
