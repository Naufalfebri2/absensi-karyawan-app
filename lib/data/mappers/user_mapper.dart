import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      token: model.token ?? "",
      fullName: model.fullName,
      email: model.email,
      role: model.role,
      employeeId: model.employeeId,
      photoUrl: model.photoUrl,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      token: entity.token,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      employeeId: entity.employeeId,
      photoUrl: entity.photoUrl,
    );
  }
}
