// To parse this JSON data, do
//
//     final productList = productListFromJson(jsonString);
//import 'dart:convert';

class CourseVideo {
  int? courseId;
  String? coursecode;
  String? courseDescription;
  String? courseImage;

  CourseVideo({
    this.courseId,
    this.coursecode,
    this.courseDescription,
    this.courseImage,
  });

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      courseId: json["courseId"],
      coursecode: json["coursecode"],
      courseDescription: json["courseDescription"],
      courseImage: json["courseImage"],
    );
  }
}
