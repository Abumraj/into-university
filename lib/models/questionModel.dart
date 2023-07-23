class Question {
  int? id;
  int? courseId;
  int? chapterId;
  String? question;
  var correctAnswer;
  var solution;
  var option2;
  var option3;
  var option4;
  var isRead;

  Question(
      {this.id,
      this.courseId,
      this.chapterId,
      this.question,
      this.correctAnswer,
      this.solution,
      this.option2,
      this.option3,
      this.option4,
      this.isRead});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        courseId: json["courseId"],
        chapterId: json["chapterId"],
        question: json["question"],
        correctAnswer: json["correctAnswer"],
        solution: json['solution'],
        option2: json["option2"],
        option3: json["option3"],
        option4: json["option4"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "courseId": courseId,
        "chapterId": chapterId,
        "question": question,
        "correctAnswer": correctAnswer,
        "solution": solution,
        "option2": option2,
        "option3": option3,
        "isRead": isRead,
      };
}
