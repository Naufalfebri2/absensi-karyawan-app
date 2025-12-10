class UserModel {
  final int id;
  final String? token; // nullable karena getProfile biasanya tanpa token
  final String fullName;
  final String email;
  final String role;
  final int employeeId;
  final String? photoUrl;

  UserModel({
    required this.id,
    this.token,
    required this.fullName,
    required this.email,
    required this.role,
    required this.employeeId,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      token: json["token"], // bisa null, aman
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      employeeId: json["employee_id"] ?? 0,
      photoUrl: json["photo_profile"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "token": token,
      "full_name": fullName,
      "email": email,
      "role": role,
      "employee_id": employeeId,
      "photo_profile": photoUrl,
    };
  }
}
