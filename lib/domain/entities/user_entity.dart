class UserEntity {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  UserEntity copyWith({
    int? id,
    String? fullName,
    String? email,
    String? role,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
