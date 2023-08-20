import 'package:objectbox/objectbox.dart';

@Entity()
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
      this.id = 0});
}

@Entity()
class Chapter {
  int? id;
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
      this.progress,
      this.id = 0});
}

@Entity()
class HighScore {
  int? id;
  String? coursecode;
  String? chapterName;
  String? score;

  HighScore({this.id = 0, this.coursecode, this.chapterName, this.score});
}

@Entity()
class FirebaseLocalNotification {
  int? id;
  String? isLive;
  String? dataTitle;
  String? dataBody;
  String? dataLink;
  String? dataImageLink;

  FirebaseLocalNotification({
    this.id,
    this.isLive,
    this.dataTitle,
    this.dataBody,
    this.dataLink,
    this.dataImageLink,
  });
}

@Entity()
class Question {
  int? id;
  int? courseId;
  int? chapterId;
  String? question;
  String? correctAnswer;
  String? solution;
  String? option2;
  String? option3;
  String? option4;
  String? isRead;

  Question(
      {this.id = 0,
      this.courseId,
      this.chapterId,
      this.question,
      this.correctAnswer,
      this.solution,
      this.option2,
      this.option3,
      this.option4,
      this.isRead});
}
