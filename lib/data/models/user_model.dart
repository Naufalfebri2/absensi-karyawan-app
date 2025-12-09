class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      role: json["role"],
      photoUrl: json["photo_profile"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "role": role,
      "photo_profile": photoUrl,
    };
  }
}
