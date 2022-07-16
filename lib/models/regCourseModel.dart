class RegCourse {
  int? courseId;
  String? courseName;
  String? coursecode;
  String? courseDescrip;
  String? expireAt;
  int? id;

  RegCourse(
      {this.courseId,
      this.courseName,
      this.coursecode,
      this.courseDescrip,
      this.expireAt,
      this.id});

  factory RegCourse.fromJson(Map<String, dynamic> json) {
    return RegCourse(
      courseId: json['courseId'],
      courseName: json['courseName'],
      coursecode: json['coursecode'],
      courseDescrip: json['courseDescrip'],
      expireAt: json['expireAt'],
    );
  }
  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseName": courseName,
        "coursecode": coursecode,
        "courseDescrip": courseDescrip,
        "expireAt": expireAt,
      };
}
