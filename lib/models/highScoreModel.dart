class HighScore {
  int? id;
  String? coursecode;
  String? chapterName;
  var score;

  HighScore({this.id, this.coursecode, this.chapterName, this.score});

  factory HighScore.fromJson(Map<String, dynamic> json) {
    return HighScore(
      coursecode: json['coursecode'],
      chapterName: json['chapterName'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        "coursecode": coursecode,
        "chapterName": chapterName,
        "score": score,
      };
}
