import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:uniapp/models/videoListModel.dart';
import 'package:uniapp/models/highScoreModel.dart';

class DbHelper {
  static const String TABLE1 = 'regCourses';
  static const String TABLE2 = 'chapters';
  static const String TABLE3 = 'questions';
  static const String TABLE4 = 'offVideo';
  static const String TABLE5 = 'highScore';
  static const String COURSE_NAME = 'courseName';
  static const String COURSE_CODE = 'coursecode';
  static const String COURSE_DESCRIP = 'courseDescrip';
  static const String CHAPTER_DESCRIP = 'chapterDescrip';
  static const String CHAPTER_NAME = 'chapterName';
  static const String QUESTION_NUMBER = 'quesNum';
  static const String QUESTION_TIME = 'quesTime';
  static const String QUESTION_NAME = 'name';
  static const String QUESTION = 'question';
  static const String CORRECT_ANSWER = 'correctAnswer';
  static const String SOLUTION = 'solution';
  static const String OPTION2 = 'option2';
  static const String OPTION3 = 'option3';
  static const String OPTION4 = 'option4';
  static const String COURSE_ID = 'courseId';
  static const String CHAPTER_ID = 'chapterId';
  static const String EXPIRE_AT = 'expireAt';
  static const String PASSWORD = 'Ranchodas17';
  static const String VIDEO_NAME = 'videoName';
  static const String VIDEO_SIZE = 'videoSize';
  static const String VIDEO_DURATION = 'duration';
  static const String VIDEO_PATH = 'videoUrl';
  static const String VIDEO_THUMB = 'thumbUrl';
  static const String VIDEO_DESCRIPTION = 'videoDescript';
  static const String USER_SCORE = 'score';
  //static Database? _db;

  Future<Database> get db async {
    Database _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'uniAcad.db');
    var db = await openDatabase(path,
        version: 1, password: PASSWORD, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE1( id INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_ID INTEGER, $COURSE_NAME TEXT, $COURSE_CODE TEXT, $COURSE_DESCRIP TEXT, $EXPIRE_AT TEXT)");
    await db.execute(
        "CREATE TABLE $TABLE2( id INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_ID INTEGER, $CHAPTER_ID INTEGER, $CHAPTER_NAME TEXT, $CHAPTER_DESCRIP TEXT, $QUESTION_NUMBER INTEGER, $QUESTION_TIME INTEGER)");
    await db.execute(
        "CREATE TABLE $TABLE3( id INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_ID INTEGER,  $CHAPTER_ID INTEGER, $QUESTION TEXT, $CORRECT_ANSWER TEXT, $SOLUTION TEXT NULLABLE, $OPTION2 TEXT NULLABLE,$OPTION3 TEXT NULLABLE,$OPTION4 TEXT NULLABLE)");
    await db.execute(
        "CREATE TABLE $TABLE4(id INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_ID INTEGER NULLABLE, $CHAPTER_ID INTEGER NULLABLE, $VIDEO_NAME TEXT, $VIDEO_PATH TEXT, $VIDEO_DESCRIPTION TEXT, $VIDEO_THUMB TEXT, $VIDEO_SIZE TEXT NULLABLE, $VIDEO_DURATION TEXT NULLABLE)");
    await db.execute(
        "CREATE TABLE $TABLE5(id INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_CODE TEXT, $CHAPTER_NAME TEXT, $USER_SCORE TEXT)");
  }

  Future<VideoList> saveVideo(VideoList videoList) async {
    var dbClient = await db;
    videoList.id = await dbClient.insert(TABLE4, videoList.toJson());
    // var result = await dbClient.rawInsert(
    //     "INSERT INTO $TABLE4 ($VIDEO_NAME, $VIDEO_PATH, $VIDEO_DESCRIPTION)"
    //     " VALUES ($videoName, $videoUrl, $videoDescript)");
    return videoList;
    //print(result);
  }

  Future deleteVideo(String url) async {
    var dbClient = await db;
    await dbClient.delete(TABLE4, where: '$VIDEO_PATH = ?', whereArgs: [url]);
    // var result = await dbClient.rawInsert(
    //     "INSERT INTO $TABLE4 ($VIDEO_NAME, $VIDEO_PATH, $VIDEO_DESCRIPTION)"
    //     " VALUES ($videoName, $videoUrl, $videoDescript)");

    //print(result);
  }

  // Method to get all saved videos from database.
  Future<List<VideoList>> getSavedVideos(chapterId) async {
    var dbClient = await db;
    var maps = await dbClient.query(
      TABLE4,
      columns: [VIDEO_NAME, VIDEO_DESCRIPTION],
      groupBy: COURSE_ID,
      orderBy: CHAPTER_ID,
      where: '$CHAPTER_ID = ?',
      whereArgs: [chapterId],
    );

    List<VideoList> allVideoList = [];
    maps.forEach((currentMap) {
      VideoList videoList = VideoList.fromJson(currentMap);
      allVideoList.add(videoList);
    });
    return allVideoList;
    //print(allRegCourse);
  }

  // Method to get all saved videos from database.
  Future<List<VideoList>> getAllSaveVideo() async {
    var dbClient = await db;
    var maps = await dbClient.query(TABLE4,
        columns: [VIDEO_NAME, VIDEO_DESCRIPTION],
        groupBy: COURSE_ID,
        orderBy: CHAPTER_ID);

    List<VideoList> allVideoList = [];
    maps.forEach((currentMap) {
      VideoList videoList = VideoList.fromJson(currentMap);
      allVideoList.add(videoList);
    });
    return allVideoList;
    //print(allRegCourse);
  }

  Future<int> truncateTable4() async {
    var dbClient = await db;
    return await dbClient.delete(
      TABLE4,
    );
  }

  //  INSERT USER SCORE TO  DATABASE.
  Future<HighScore> saveHighScore(HighScore highScore) async {
    var dbClient = await db;
    highScore.id = await dbClient.insert(TABLE5, highScore.toJson());
    return highScore;
  }

  // Method to get all user scores from database.
  Future<List<HighScore>> getAllHighScore(String coursecode) async {
    var dbClient = await db;
    var maps = await dbClient.query(TABLE5,
        columns: [COURSE_CODE, CHAPTER_NAME, USER_SCORE],
        where: '$COURSE_CODE = ?',
        whereArgs: [coursecode],
        groupBy: COURSE_CODE,
        orderBy: CHAPTER_NAME);

    List<HighScore> allRegCourse = [];
    maps.forEach((currentMap) {
      HighScore regCourse = HighScore.fromJson(currentMap);
      allRegCourse.add(regCourse);
    });
    return allRegCourse;
    //print(allRegCourse);
  }

  //  TO INSERT REGISTERED COURSES TO  DATABASE.
  Future<RegCourse> saveRegCourse(RegCourse regCourse) async {
    var dbClient = await db;
    regCourse.id = await dbClient.insert(TABLE1, regCourse.toJson());
    return regCourse;
  }

  // Method to get all registered courses from database.
  Future<List<RegCourse>> getAllRegCourse() async {
    var dbClient = await db;
    var maps = await dbClient.query(TABLE1,
        columns: [COURSE_ID, COURSE_NAME, COURSE_CODE, COURSE_DESCRIP]);

    List<RegCourse> allRegCourse = [];
    maps.forEach((currentMap) {
      RegCourse regCourse = RegCourse.fromJson(currentMap);
      allRegCourse.add(regCourse);
    });
    print(allRegCourse);
    return allRegCourse;
  }

  // METHOD TO INSERT SPECIFIC CHAPTER TO  DATABASE.
  Future saveChapterAsync(List<Chapter> chapters) {
    print(chapters);
    return compute(saveChapter, chapters);
  }

  saveChapter(List<Chapter> chapters) async {
    Database dbClient = await db;
    dbClient.transaction((txn) async {
      Batch batch = txn.batch();
      for (var sharp in chapters) {
        Map<String, dynamic> chapter = {
          COURSE_ID: sharp.courseId,
          CHAPTER_ID: sharp.chapterId,
          CHAPTER_NAME: sharp.chapterName,
          CHAPTER_DESCRIP: sharp.chapterDescrip,
          QUESTION_NUMBER: sharp.quesNum,
          QUESTION_TIME: sharp.quesTime
        };
        batch.insert(TABLE2, chapter);
      }
      batch.commit();
    });
  }

// Method to get all CHAPTERS OF A SPECIFIC COURSE from database.
  Future<List<Chapter>> getAllChapters(int courseId) async {
    List<Chapter> chapter = [];
    Database dbClient = await db;
    // Batch batch = txn.batch();
    var maps = await dbClient.query(
      TABLE2,
      columns: [
        CHAPTER_NAME,
        CHAPTER_ID,
        CHAPTER_DESCRIP,
        QUESTION_NUMBER,
        QUESTION_TIME
      ],
      where: '$COURSE_ID = ?',
      whereArgs: [courseId],
    );
    // chapter = maps.cast<Chapter>();
    // await batch.commit();
    maps.forEach((currentMap) {
      Chapter courseChapter = Chapter.fromJson(currentMap);
      chapter.add(courseChapter);
    });
    print(chapter);
    return chapter;
  }

//  // METHOD TO INSERT QUESTIONS BELONGING TO A SPECIFIC CHAPTER OF A PARTICULAR COURSE INTO  DATABASE.
  Future saveQuestionAsync(List<Question> questions) {
    return compute(saveQuestion, questions);
  }

  saveQuestion(List<Question> questions) async {
    Database dbClient = await db;
    dbClient.transaction((txn) async {
      Batch batch = txn.batch();
      for (var sharp in questions) {
        Map<String, dynamic> question = {
          COURSE_ID: sharp.courseId,
          CHAPTER_ID: sharp.chapterId,
          QUESTION: sharp.question,
          CORRECT_ANSWER: sharp.correctAnswer,
          SOLUTION: sharp.solution,
          OPTION2: sharp.option2,
          OPTION3: sharp.option3,
          OPTION4: sharp.option4,
        };
        batch.insert(TABLE3, question);
      }
      batch.commit(noResult: true);
    });
  }

//  Future<List<Question>> saveQuestions (Question question) async{
//    var dbClient = await db;
//    Batch batch = dbClient.batch();
//    batch.insert(TABLE3, question.toJson());
//  }

  // Method to get all QUESTIONS OF A SPECIFIC CHAPTER BELONGING TO A PARTICULAR COURSE courses from database.
  Future<List<Question>> getAllQuestions(
      int chapterId, int chapterNumber) async {
    List<Question> questions = [];
    List<Question> questionaire = [];
    Database dbClient = await db;
    // Batch batch = txn.batch();
    var maps = await dbClient.query(
      TABLE3,
      columns: [QUESTION, CORRECT_ANSWER, SOLUTION, OPTION2, OPTION3, OPTION4],
      where: '$CHAPTER_ID = ?',
      whereArgs: [chapterId],
    );
    // question = await batch.commit() as List<Question>;
    maps.forEach((currentMap) {
      Question courseChapter = Question.fromJson(currentMap);
      questions.add(courseChapter);
    });
    questions.shuffle();
    var quwes = questions.take(chapterNumber);
    questionaire.addAll(quwes);
    print(chapterNumber);
    print(questions);
    return questionaire;
  }

//  Future<List<Question>> getAllQuestions(String coursecode, String chapterName) async {
//    var dbClient = await db;
//    var maps = await dbClient.query(TABLE3, columns: [QUESTION, COURSE_DESCRIP, CORRECT_ANSWER, OPTION2, OPTION3, OPTION4],
//      where: '$COURSE_CODE = ? : $CHAPTER_NAME = ?', whereArgs: [coursecode, chapterName] ,);
//    List<Question> questions = List<Question>();
//    maps.forEach((currentMap){
//      Question courseChapter = Question.fromJson(currentMap);
//      questions.add(courseChapter);
//    });
//    return questions;
//  }

//  // METHOD TO INSERT DEMO COURSES TO  DATABASE.
//  Future<RegCourse> saveRegDemoCourse (RegCourse regCourse) async{
//    var dbClient = await db;
//    regCourse.id = await dbClient.insert(DEMO_TABLE1, regCourse.toJson());
//    return regCourse;
//  }
//  // Method to get all registered courses from database.
//  Future<List<RegCourse>> getAllRegDemoCourse() async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.query(DEMO_TABLE1, columns: [COURSE_NAME, COURSE_CODE, COURSE_DESCRIP]);
//
//    List<RegCourse> allRegCourse = List<RegCourse>();
//    maps.forEach((currentMap){
//      RegCourse regCourse = RegCourse.fromJson(currentMap);
//      allRegCourse.add(regCourse);
//    });
//    print(maps);
//
//    return allRegCourse;
//  }

//  // METHOD TO INSERT SPECIFIC CHAPTER TO  DATABASE.
//  Future<Chapter> saveDemoChapter (Chapter chapter) async{
//    var dbClient = await db;
//    chapter.id = await dbClient.insert(DEMO_TABLE2, chapter.toJson());
//    return chapter;
//  }
//
//// Method to get all CHAPTERS OF A SPECIFIC COURSE from database.
//  Future<List<Chapter>> getAllDemoChapters(String  coursecode) async {
//    var dbClient = await db;
//    var maps = await dbClient.query(DEMO_TABLE2, columns: [CHAPTER_NAME, COURSE_CODE, CHAPTER_DESCRIP, QUESTION_NUMBER, QUESTION_TIME],
//      where: '$COURSE_CODE = ?', whereArgs: [coursecode] ,);
//    List<Chapter> chapter = List<Chapter>();
//    maps.forEach((currentMap){
//      Chapter courseChapter = Chapter.fromJson(currentMap);
//      chapter.add(courseChapter);
//    });
//
//    print(maps);
//    return chapter;
//  }
//
//
//  // METHOD TO INSERT QUESTIONS BELONGING TO A SPECIFIC CHAPTER OF A PARTICULAR COURSE INTO  DATABASE.
//  Future<Question> saveDemoQuestions (Question question) async{
//    var dbClient = await db;
//    question.id = await dbClient.insert(DEMO_TABLE3, question.toJson());
//    return question;
//  }
//
//  // Method to get all QUESTIONS OF A SPECIFIC CHAPTER BELONGING TO A PARTICULAR COURSE courses from database.
//  Future<List<Question>> getAllDemoQuestions(String coursecode, String chapterName) async {
//    var dbClient = await db;
//    var maps = await dbClient.query(DEMO_TABLE3, columns: [QUESTION, CORRECT_ANSWER, OPTION2, OPTION3, OPTION4],
//      where: "$COURSE_CODE = ? and  $CHAPTER_NAME = ?" , whereArgs: [coursecode, chapterName] ,);
//    List<Question> questions = List<Question>();
//    maps.forEach((currentMap){
//      Question courseChapter = Question.fromJson(currentMap);
//      questions.add(courseChapter);
//    });
//    print(maps);
//    return questions;
//  }
  //method to delete table 1
  Future<int> truncateTable1() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE1);
  }

  // method to delete table 2
  Future<int> truncateTable2() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE2);
  }

  // method to delete table 3
  Future<int> truncateTable3() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE3);
  }

//  //method to delete table 1
//  Future<void> truncateDemoTable1() async {
//    var dbClient = await db;
//    return await dbClient.delete(DEMO_TABLE1);
//  }
//
//  // method to delete table 2
//  Future<void> truncateDemoTable2() async {
//    var dbClient = await db;
//    return await dbClient.delete(DEMO_TABLE2);
//
//  }
//  // method to delete table 3
//  Future<void> truncateDemoTable3() async {
//    var dbClient = await db;
//    return await dbClient.delete(DEMO_TABLE3);
//  }
  // METHOD TO CLOSE THE DATABASE CONNECTION.
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
