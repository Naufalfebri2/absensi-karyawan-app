import '../../domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: _parseInt(json['id'] ?? json['employee_id']),
      name: json['name'] ?? json['full_name'] ?? json['employee_name'] ?? '',
      email: json['email'] ?? '',
      position:
          json['position'] ?? json['position_name'] ?? json['jabatan'] ?? '',
      department:
          json['department'] ?? json['department_name'] ?? json['divisi'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(UserEntity user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'position': user.position,
      'department': user.department,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
