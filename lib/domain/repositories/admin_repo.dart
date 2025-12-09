import '../entities/shift_entity.dart';
import '../entities/user_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>> getAllEmployees();
  Future<List<ShiftEntity>> getAllShifts();
  Future<ShiftEntity> createShift(ShiftEntity shift);
  Future<ShiftEntity> updateShift(ShiftEntity shift);
  Future<void> deleteShift(int shiftId);
}
