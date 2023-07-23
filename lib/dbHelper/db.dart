import 'dart:async';
import 'package:uniapp/main.dart';
import 'package:uniapp/objectbox.g.dart';
import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';

import '../entities.dart';

class ObjectBox {
  late final Store store;
  late final Box<RegCourse> regCourseBox;
  late final Box<Chapter> chapterBox;
  late final Box<Question> questionBox;
  late final Box<HighScore> highScoreBox;
  late final Box<FirebaseLocalNotification> firebaseLocalNotificationBox;
  ObjectBox._create(this.store) {
    regCourseBox = Box<RegCourse>(store);
    chapterBox = Box<Chapter>(store);
    questionBox = Box<Question>(store);
    highScoreBox = Box<HighScore>(store);
    firebaseLocalNotificationBox = Box<FirebaseLocalNotification>(store);
  }

  static Future<ObjectBox> create() async {
    final docsdir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsdir.path, 'uniApp'));
    return ObjectBox._create(store);
  }

  static Future<void> saveNotification(
      isLive, title, link, body, imageLink) async {
    final notify = FirebaseLocalNotification(
        isLive: isLive,
        dataBody: body,
        dataImageLink: imageLink,
        dataLink: link,
        dataTitle: title);
    objectBox.firebaseLocalNotificationBox.put(notify);
  }

  // Method to get all saved videos from database.
  static Future<List<FirebaseLocalNotification>> getAllNotification() async {
    final query = objectBox.firebaseLocalNotificationBox
        .query()
        .order(FirebaseLocalNotification_.id, flags: Order.descending)
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  static Future<void> saveHighScore(
      String coursecode, String chapterName, String score) async {
    var highScore = HighScore(
        coursecode: coursecode, chapterName: chapterName, score: score);
    objectBox.highScoreBox.put(highScore);
  }

  static Future<List<HighScore>> getAllHighScore(String coursecode) async {
    final query =
        (objectBox.highScoreBox.query(HighScore_.coursecode.equals(coursecode))
              ..order(HighScore_.chapterName))
            .build();
    final result = query.find();
    query.close();
    return result;
  }

  //  TO INSERT REGISTERED COURSES TO  DATABASE.
  static Future<RegCourse> saveRegCourse(RegCourse regCourse) async {
    objectBox.regCourseBox.put(regCourse);
    return regCourse;
  }

  // Method to get all registered courses from database.
  static Future<List<RegCourse>> getAllRegCourse() async {
    return objectBox.regCourseBox.getAll();
  }

  // METHOD TO INSERT SPECIFIC CHAPTER TO  DATABASE.
  static Future<void> saveChapter(List<Chapter> chapters) async {
    objectBox.chapterBox.putMany(chapters);
  }

  // Method to get all CHAPTERS OF A SPECIFIC COURSE from database.
  static Future<List<Chapter>> getAllChapters(int courseId) async {
    final query =
        (objectBox.chapterBox.query(Chapter_.courseId.equals(courseId))
              ..order(Chapter_.chapterOrderId))
            .build();

    final result = query.find();
    query.close();

    return result;
  }

  static Future<List<Chapter>> getSavedChapters() async {
    return objectBox.chapterBox.getAll();
  }

  // METHOD TO INSERT QUESTIONS BELONGING TO A SPECIFIC CHAPTER OF A PARTICULAR COURSE INTO  DATABASE.
  static Future<void> saveQuestion(List<Question> questions) async {
    objectBox.questionBox.putMany(questions);
  }

  // Method to get all QUESTIONS OF A SPECIFIC CHAPTER BELONGING TO A PARTICULAR COURSE courses from database.
  static Future<List<Question>> getAllQuestions(
      int chapterId, int chapterNumber) async {
    final query =
        (objectBox.questionBox.query(Question_.chapterId.equals(chapterId)))
            .build();
    final result = query.find();
    query.close();
    result.shuffle();
    var quwes = result.take(chapterNumber);
    return quwes.toList();
  }

  static Future<List<Question>> getSavedQuestions() async {
    return objectBox.questionBox.getAll();
  }

  //METHOD TO UPDATE QUESTION TABLE OF USER PROGRESS
  static Future<int> passedQuestion(id) async {
    final query = objectBox.questionBox.query(Question_.id.equals(id)).build();
    final result = query.findFirst();
    Question que = Question(
        id: result!.id,
        chapterId: result.chapterId,
        question: result.question,
        correctAnswer: result.correctAnswer,
        courseId: result.courseId,
        option2: result.option2,
        option3: result.option3,
        option4: result.option4,
        solution: result.solution,
        isRead: "1");
    return objectBox.questionBox.put(que);
  }

  //METHOD TO UPDATE QUESTION TABLE OF USER PROGRESS
  static Future<int> updateCourseProgress(int progress, int courseId) async {
    final query = objectBox.regCourseBox
        .query(RegCourse_.courseId.equals(courseId))
        .build();
    final result = query.findFirst();
    query.close();

    RegCourse course = RegCourse(
        id: result!.id,
        courseId: courseId,
        progress: progress,
        coursecode: result.coursecode,
        courseName: result.courseName,
        courseChatLink: result.courseChatLink,
        courseDescrip: result.courseDescrip,
        courseImage: result.courseImage,
        expireAt: result.expireAt,
        courseMaterialLink: result.courseMaterialLink);
    return objectBox.regCourseBox.put(course);
  }

  //METHOD TO UPDATE QUESTION TABLE OF USER PROGRESS
  static Future<int> updateChapterProgress(progress, chapterId) async {
    final query = objectBox.chapterBox
        .query(Chapter_.chapterId.equals(chapterId))
        .build();
    final result = query.findFirst();
    query.close();
    Chapter chap = Chapter(
        id: result!.id,
        progress: progress,
        chapterId: chapterId,
        chapterName: result.chapterName,
        courseId: result.courseId,
        quesNum: result.quesNum,
        quesTime: result.quesTime,
        chapterDescrip: result.chapterDescrip,
        chapterOrderId: result.chapterOrderId);
    return objectBox.chapterBox.put(chap);
  }

  // USER COURSE PROGRESS
  static Future<int> courseProgress(courseId) async {
    int doneLength = 0;

    final query =
        (objectBox.questionBox.query(Question_.courseId.equals(courseId)))
            .build();
    final result = query.find();
    query.close();
    int totalQuestion = result.length;
    result.forEach((element) {
      if (element.isRead == "1") {
        doneLength++;
      }
    });

    int courseProgress = ((doneLength / totalQuestion) * 100).ceil();
    return courseProgress;
  }

// USER CHAPTER PROGRESS
  static Future<int> chapterProgress(chapterId) async {
    int doneLength = 0;
    final query = objectBox.questionBox
        .query(Question_.chapterId.equals(chapterId))
        .build();
    final maps = query.find();
    query.close();
    int totalQuestion = maps.length;
    maps.forEach((element) {
      if (element.isRead == "1") {
        doneLength++;
      }
    });
    int courseProgress = ((doneLength / totalQuestion) * 100).ceil();
    return courseProgress;
  }

  // method to delete table 2
  static Future<int> truncateTable2() async {
    return objectBox.regCourseBox.removeAll();
  }

  // method to delete table 3
  static Future<int> truncateTable3() async {
    return objectBox.chapterBox.removeAll();
  }

  // method to delete table 3
  static Future<int> truncateTable5() async {
    return objectBox.questionBox.removeAll();
  }

  // method to delete table 3
  static Future<int> truncateTable6() async {
    return objectBox.highScoreBox.removeAll();
  }
}
