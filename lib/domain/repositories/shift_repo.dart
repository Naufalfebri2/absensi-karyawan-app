import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<List<ShiftEntity>> getShifts();

  Future<ShiftEntity> updateShift(ShiftEntity shift);
}
