class DepartCourse {
  int? courseId;
  String? courseName;
  String? coursecode;
  String? comment;
  String? introUrl;
  int? coursePrice;
  int? cartTotal;
  int? courseUnit;

  DepartCourse(
      {this.courseId,
      this.courseName,
      this.coursecode,
      this.comment,
      this.coursePrice,
      this.courseUnit,
      this.cartTotal,
      this.introUrl});

  factory DepartCourse.fromJson(Map<String, dynamic> json) {
    return DepartCourse(
      courseId: json['courseId'],
      courseName: json['courseName'],
      coursecode: json['coursecode'],
      comment: json['comment'],
      coursePrice: json['coursePrice'],
      courseUnit: json['courseUnit'],
      introUrl: json['introUrl'],
      cartTotal: json['cartTotal'],
    );
  }
  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseName": courseName,
        "coursecode": coursecode,
        "comment": comment,
        "coursePrice": coursePrice,
        "courseUnit": courseUnit,
        "cartTotal": cartTotal,
        "introUrl": introUrl,
      };
}
