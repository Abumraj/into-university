import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/screens/home.dart';
import '../entities.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../widgets/courseHeader.dart';
import '../widgets/hexColor.dart';
import '../widgets/theme_helper.dart';

class Refresh extends StatefulWidget {
  @override
  _RefreshState createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  bool isLoadingCourse = false;
  bool isLoadingChapter = false;
  bool isLoadingQuestions = false;
  bool isDoneLoading = false;
  bool isGeneratingCode = false;
  List<RegCourse> course = [];
  Future<List<dynamic>>? regCourse;
  List<Chapter> chapter = [];
  List<dynamic> regCourses = [];
  int counter = 0;
  List<Question> question = [];
  List<dynamic> quest = [];
  @override
  void initState() {
    _loadAndSave();
    super.initState();
  }

  Future _loadAndSave() async {
    isLoadingCourse = true;
    await ObjectBox.truncateTable2();
    await _apiRepository.getRegCourse().then((allRegCourse) {
      allRegCourse.forEach((element) {
        var cour = RegCourse(
            courseId: element.courseId,
            courseName: element.courseName,
            coursecode: element.coursecode,
            courseImage: element.courseImage,
            courseDescrip: element.courseDescrip,
            courseChatLink: element.courseChatLink,
            courseMaterialLink: element.courseMaterialLink,
            expireAt: element.expireAt,
            progress: element.progress);
        course.add(cour);
      });
      ObjectBox.getAllRegCourse().then((value) {
        if (value.isNotEmpty) {
          value.forEach((val) {
            course
                .removeWhere((element) => element.coursecode == val.coursecode);
          });
        }
        if (course.isNotEmpty) {
          insert(course[0]);
        }
      });
      setState(() {
        isLoadingCourse = false;
        isLoadingChapter = true;
      });
      ObjectBox.truncateTable3();

      _apiRepository.getChapter().then((allchapter) {
        allchapter.forEach((element) {
          var chapt = Chapter(
              chapterId: element.chapterId,
              courseId: element.courseId,
              chapterName: element.chapterName,
              chapterOrderId: element.chapterOrderId,
              chapterDescrip: element.chapterDescrip,
              quesNum: element.quesNum,
              quesTime: element.quesTime,
              progress: element.progress);
          chapter.add(chapt);
        });
        ObjectBox.getSavedChapters().then((value) {
          if (value.isNotEmpty) {
            value.forEach((val) {
              chapter
                  .removeWhere((element) => element.chapterId == val.chapterId);
            });
          }
        });
        if (chapter.isNotEmpty) {
          ObjectBox.saveChapter(chapter);
        }
      });
      setState(() {
        isLoadingChapter = false;
        isLoadingQuestions = true;
      });
      ObjectBox.truncateTable5();

      _apiRepository.getQuestions().then((allquestion) {
        allquestion.forEach((element) {
          var quest = Question(
              courseId: element.courseId,
              chapterId: element.chapterId,
              question: element.question,
              correctAnswer: element.correctAnswer.toString(),
              option2: element.option2.toString(),
              option3: element.option3.toString(),
              option4: element.option4.toString(),
              isRead: element.isRead.toString());
          question.add(quest);
        });
        ObjectBox.getSavedQuestions().then((value) {
          if (value.isNotEmpty) {
            value.forEach((val) {
              question.removeWhere((element) =>
                  element.question.toString() == val.question.toString());
            });
          }
        });
        if (question.isNotEmpty) {
          ObjectBox.saveQuestion(question);
        }
      });
      setState(() {
        isLoadingQuestions = false;
        isDoneLoading = true;
      });
    });
  }

  insert(RegCourse regCourse) {
    ObjectBox.saveRegCourse(regCourse).then((val) {
      counter = counter + 1;
      if (counter >= course.length) {
        return;
      }
      RegCourse a = course[counter];
      insert(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text(
          "Course Resources",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          HeaderWidget1(150, true, "Fetch Course Resources"),
          Padding(padding: EdgeInsets.all(20)),
          Center(
            child: Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: isDoneLoading
                        ? Icon(
                            Icons.done_all,
                            color: Colors.purple,
                            size: 5.0,
                          )
                        : CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.purple),
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.purple,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [
                          HexColor("#DC54FE"),
                          HexColor("#8A02AE"),
                        ],
                      ),
                      color: Colors.deepPurple.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          isDoneLoading
                              ? "Continue"
                              : isLoadingCourse
                                  ? "Course Loading"
                                  : isLoadingChapter
                                      ? "Chapters Loading"
                                      : isLoadingQuestions
                                          ? "Questions Loading"
                                          : "Please Wait",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (isDoneLoading) Get.offAll(Home());
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
