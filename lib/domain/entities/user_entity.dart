class UserEntity {
  final int id;
  final String token;
  final String fullName;
  final String email;
  final String role;
  final int employeeId;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.token,
    required this.fullName,
    required this.email,
    required this.role,
    required this.employeeId,
    this.photoUrl,
  });

  UserEntity copyWith({
    int? id,
    String? token,
    String? fullName,
    String? email,
    String? role,
    int? employeeId,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      token: token ?? this.token,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
