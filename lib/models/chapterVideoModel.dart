class ChapterList {
  int? chapterId;
  String? chapterName;
  String? chapterImage;
  int? chapterVideoNum;
  String? chapterDescrip;

  ChapterList({
    this.chapterId,
    this.chapterImage,
    this.chapterVideoNum,
    this.chapterName,
    this.chapterDescrip,
  });

  factory ChapterList.fromJson(Map<String, dynamic> json) {
    return ChapterList(
      chapterId: json['chapterId'],
      chapterImage: json['chapterImage'],
      chapterVideoNum: json['chapterVideoNum'],
      chapterDescrip: json['chapterDescrip'],
      chapterName: json['chapterName'],
    );
  }

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "chapterImage": chapterImage,
        "chapterVideoNum": chapterVideoNum,
        "chapterDescrip": chapterDescrip,
        "chapterName": chapterName,
      };
}
