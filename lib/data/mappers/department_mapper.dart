import '../../domain/entities/department_entity.dart';
import '../models/department_model.dart';

class DepartmentMapper {
  static DepartmentEntity toEntity(DepartmentModel model) {
    return DepartmentEntity(
      id: model.id,
      name: model.name,
      description: model.description,
    );
  }

  static DepartmentModel toModel(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
    );
  }
}
