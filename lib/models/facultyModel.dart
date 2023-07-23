class Faculty {
  int? facultyId;
  String? facultyName;
 
  Faculty({this.facultyId,  this.facultyName});
 
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      facultyId: json['facultyId'],
      facultyName: json['facultyName'],
    );
  }
}