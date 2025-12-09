import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      fullName: model.fullName,
      email: model.email,
      role: model.role,
      photoUrl: model.photoUrl,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      photoUrl: entity.photoUrl,
    );
  }
}
