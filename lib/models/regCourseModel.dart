class RegCourse {
  int? courseId;
  String? courseName;
  String? coursecode;
  String? courseDescrip;
  String? expireAt;
  String? courseImage;
  int? progress;
  String? courseChatLink;
  String? courseMaterialLink;
  int? id;

  RegCourse(
      {this.courseId,
      this.courseName,
      this.coursecode,
      this.courseDescrip,
      this.expireAt,
      this.courseImage,
      this.progress,
      this.courseChatLink,
      this.courseMaterialLink,
      this.id});

  factory RegCourse.fromJson(Map<String, dynamic> json) {
    return RegCourse(
      courseId: json['courseId'],
      courseName: json['courseName'],
      coursecode: json['coursecode'],
      courseDescrip: json['courseDescrip'].toString(),
      expireAt: json['expireAt'],
      courseImage: json['courseImage'],
      progress: json['progress'],
      courseChatLink: json['courseChatLink'],
      courseMaterialLink: json['courseMaterialLink'],
    );
  }
  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseName": courseName,
        "coursecode": coursecode,
        "courseDescrip": courseDescrip,
        "expireAt": expireAt,
        "courseImage": courseImage,
        "progress": progress,
        "courseChatLink": courseChatLink,
        "courseMaterialLink": courseMaterialLink,
      };
}
