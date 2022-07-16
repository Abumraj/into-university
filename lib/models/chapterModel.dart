class Chapter {
  int? chapterId;
  int? courseId;
  String? chapterDescrip;
  String? chapterName;
  int? quesNum;
  int? quesTime;

  Chapter(
      {this.chapterId,
      this.courseId,
      this.chapterName,
      this.chapterDescrip,
      this.quesNum,
      this.quesTime});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'],
      courseId: json['courseId'],
      chapterDescrip: json['chapterDescrip'],
      chapterName: json['chapterName'],
      quesNum: json['quesNum'],
      quesTime: json['quesTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "courseId": courseId,
        "chapterDescrip": chapterDescrip,
        "chapterName": chapterName,
        "quesNum": quesNum,
        "quesTime": quesTime,
      };
}
