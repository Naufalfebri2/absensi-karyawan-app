class DepartmentModel {
  final int id;
  final String name;
  final String? description;

  DepartmentModel({required this.id, required this.name, this.description});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json["department_id"],
      name: json["department_name"],
      description: json["description"],
    );
  }
}
