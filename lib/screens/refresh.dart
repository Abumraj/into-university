import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/screens/home.dart';

import '../repository/apiRepositoryimplementation.dart';
import '../widgets/courseHeader.dart';
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
  DbHelper _dbHelper = DbHelper();
  List<RegCourse> course = [];
  Future<List<dynamic>>? regCourse;
  List<Chapter> courses = [];
  List<dynamic> regCourses = [];
  int counter = 0;
  List<Question> question = [];
  List<dynamic> quest = [];
  @override
  void initState() {
    // _getUserTypeIjjnState();
    _loadAndSave();
    super.initState();
  }

  // _getUserTypeIjjnState() async {
  //   await Constants.getUserMailSharedPreference().then((value) {
  //     setState(() {
  //       email = value.toString();
  //     });
  //   });
  //   await Constants.getUserTokenSharedPreference().then((value) {
  //     setState(() {
  //       token = value.toString();
  //     });
  //   });
  //   await Constants.getUserTypeSharedPreference().then((value) {
  //     setState(() {
  //       userType = value.toString();
  //     });
  //   });
  // }

  Future _loadAndSave() async {
    isLoadingCourse = true;
    await _apiRepository.getRegCourse().then((allRegCourse) {
      course = allRegCourse;
      print(course[0]);
      _dbHelper.truncateTable1().then((value) {
        insert(course[0]);
      });
      setState(() {
        isLoadingCourse = false;
        isLoadingChapter = true;
      });
      _apiRepository.getChapter().then((value) {
        _dbHelper.truncateTable2();
        _dbHelper.saveChapter(value);
        print(value);
      });

      setState(() {
        isLoadingChapter = false;
        isLoadingQuestions = true;
      });
      _apiRepository.getQuestions().then((value) {
        _dbHelper.truncateTable3();
        _dbHelper.saveQuestion(value);
        print(value);
      });
      setState(() {
        isLoadingQuestions = false;
        isDoneLoading = true;
      });
    });
  }

  insert(RegCourse regCourse) {
    _dbHelper.saveRegCourse(regCourse).then((val) {
      counter = counter + 1;
      if (counter >= course.length) {
        return;
      }
      RegCourse a = course[counter];
      insert(a);
      print(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Course Resources",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          HeaderWidget1(150, true, "Fetch Course Resources"),
          Padding(padding: EdgeInsets.all(20)),
          Container(
            child: Center(
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
                  Padding(
                      padding: EdgeInsets.all(8.0),
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
                          if (isDoneLoading)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                        },
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
