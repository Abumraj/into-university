class DepartCourse {
  int? courseId;
  String? courseName;
  String? coursecode;
  String? introUrl;
  late int coursePrice;
  int? courseUnit;

  DepartCourse(
      {this.courseId,
      this.courseName,
      this.coursecode,
      required this.coursePrice,
      this.courseUnit,
      this.introUrl});

  factory DepartCourse.fromJson(Map<String, dynamic> json) {
    return DepartCourse(
      courseId: json['courseId'],
      courseName: json['courseName'],
      coursecode: json['coursecode'],
      coursePrice: json['coursePrice'],
      courseUnit: json['courseUnit'],
      introUrl: json['introUrl'],
    );
  }
  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseName": courseName,
        "coursecode": coursecode,
        "coursePrice": coursePrice,
        "courseUnit": courseUnit,
        "introUrl": introUrl,
      };
}
