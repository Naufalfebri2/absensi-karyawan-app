class UserEntity {
  final int id;
  final String name;
  final String email;
  final String position;
  final String department;

  // 🔥 PHONE NUMBER (STRING)
  final String? phoneNumber;

  // 🔥 AVATAR
  final String? avatarUrl;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.department,
    this.phoneNumber,
    this.avatarUrl,
  });

  // ===============================
  // COPY WITH
  // ===============================
  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? position,
    String? department,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      position: position ?? this.position,
      department: department ?? this.department,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
