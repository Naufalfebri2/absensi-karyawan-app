import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repo.dart';
import '../datasources/remote/shift_remote.dart';
import '../mappers/shift_mapper.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftRemote remote;

  ShiftRepositoryImpl(this.remote);

  @override
  Future<List<ShiftEntity>> getShifts() async {
    final data = await remote.getShifts();
    return data.map((e) => ShiftMapper.toEntity(e)).toList();
  }

  @override
  Future<ShiftEntity> updateShift(ShiftEntity shift) async {
    final model = ShiftMapper.toModel(shift);
    final result = await remote.updateShift(model);
    return ShiftMapper.toEntity(result);
  }
}
