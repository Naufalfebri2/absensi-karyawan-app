import '../../domain/entities/department_entity.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/admin_repo.dart';
import '../datasources/remote/admin_remote.dart';
import '../mappers/department_mapper.dart';
import '../mappers/shift_mapper.dart';
import '../mappers/user_mapper.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemote remote;

  AdminRepositoryImpl(this.remote);

  @override
  Future<List<UserEntity>> getAllEmployees() async {
    final result = await remote.getAllEmployees();
    return result.map((e) => UserMapper.toEntity(e)).toList();
  }

  @override
  Future<List<DepartmentEntity>> getAllDepartments() async {
    final result = await remote.getAllDepartments();
    return result.map((e) => DepartmentMapper.toEntity(e)).toList();
  }

  @override
  Future<List<ShiftEntity>> getAllShifts() async {
    final result = await remote.getAllShifts();
    return result.map((e) => ShiftMapper.toEntity(e)).toList();
  }

  @override
  Future<ShiftEntity> createShift(ShiftEntity shift) async {
    final model = await remote.createShift(ShiftMapper.toModel(shift));
    return ShiftMapper.toEntity(model);
  }

  @override
  Future<ShiftEntity> updateShift(ShiftEntity shift) async {
    final model = await remote.updateShift(ShiftMapper.toModel(shift));
    return ShiftMapper.toEntity(model);
  }

  @override
  Future<DepartmentEntity> createDepartment(DepartmentEntity department) async {
    final model = await remote.createDepartment(
      DepartmentMapper.toModel(department),
    );
    return DepartmentMapper.toEntity(model);
  }

  @override
  Future<DepartmentEntity> updateDepartment(DepartmentEntity department) async {
    final model = await remote.updateDepartment(
      DepartmentMapper.toModel(department),
    );
    return DepartmentMapper.toEntity(model);
  }

  @override
  Future<void> deleteDepartment(int departmentId) {
    return remote.deleteDepartment(departmentId);
  }

  @override
  Future<void> deleteShift(int shiftId) {
    return remote.deleteShift(shiftId);
  }
}
