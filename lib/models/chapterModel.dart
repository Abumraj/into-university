class Chapter {
  int? chapterId;
  int? chapterOrderId;
  int? courseId;
  String? chapterDescrip;
  String? chapterName;
  int? quesNum;
  int? quesTime;
  int? progress;

  Chapter(
      {this.chapterId,
      this.courseId,
      this.chapterName,
      this.chapterOrderId,
      this.chapterDescrip,
      this.quesNum,
      this.quesTime,
      this.progress});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'],
      chapterOrderId: json['chapterOrderId'],
      courseId: json['courseId'],
      chapterDescrip: json['chapterDescrip'],
      chapterName: json['chapterName'],
      quesNum: json['quesNum'],
      quesTime: json['quesTime'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "chapterOrderId": chapterOrderId,
        "courseId": courseId,
        "chapterDescrip": chapterDescrip,
        "chapterName": chapterName,
        "quesNum": quesNum,
        "quesTime": quesTime,
        "progress": progress,
      };
}
