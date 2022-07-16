class Department {
  int? departmentId;
  int? facultyId;
  String? departmentName;

  Department({this.facultyId, this.departmentId, this.departmentName});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['DepartmentId'],
      facultyId: json['facultyId'],
      departmentName: json['departmentName'],
    );
  }
}
