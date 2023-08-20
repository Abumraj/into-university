// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dbHelper/db.dart';
import '../entities.dart';
import 'demoChapter.dart';

//import 'error.dart';

class PostUtme extends StatefulWidget {
  final String? coursecode;
  final int? courseId;
  PostUtme({Key? key, this.coursecode, this.courseId}) : super(key: key);

  @override
  State<PostUtme> createState() => _PostUtmeState();
}

class _PostUtmeState extends State<PostUtme> {
  List<Chapter> chapter = [];
  List<Chapter> exam = [];
  List<Question> questions = [];
  bool isLoading = false;

  @override
  void initState() {
    loadChapter();
    super.initState();
  }

  loadChapter() async {
    setState(() {
      isLoading = true;
    });

    final result = await ObjectBox.getAllChapters(widget.courseId!);
    if (result.isNotEmpty) {
      setState(() {
        chapter = result;
        isLoading = false;
      });
    } else {
      GetSnackBar(
        message: 'No Chapter Allocated For this course',
      );
    }
  }

  loadQuestion(int chapterId, chapterName, quesNum, quesTime) async {
    final result = await ObjectBox.getAllQuestions(chapterId, quesNum);
    if (result.isNotEmpty) {
      setState(() {
        questions = result;
      });
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
    Get.bottomSheet(QuizOptionsDialog(
      questions: questions,
      regCourse: widget.coursecode,
      chapterName: chapterName,
      courseId: widget.courseId!.toInt(),
      chapterId: chapterId,
      quesNum: quesNum,
      quesTime: quesTime,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.purple,
          title: Text(widget.coursecode.toString().toUpperCase()),
          elevation: 0,
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: ThemeData.light().primaryColor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: chapter.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      color: Colors.white,
                      elevation: 0.0,
                      shadowColor: Colors.purple,
                      child: Column(
                        children: [
                          ListTile(
                              leading: CircleAvatar(
                                child: Image.asset("images/uniappLogo.png"),
                                backgroundColor: Colors.white,
                              ),
                              title: Text(chapter[index].chapterName.toString(),
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  chapter[index].chapterDescrip.toString(),
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)),
                              trailing: chapter[index].quesTime!.toInt() > 0
                                  ? Text("${chapter[index].quesTime} mins",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold))
                                  : Text("practice Mode",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)),
                              onTap: () {
                                loadQuestion(
                                    chapter[index].chapterId!.toInt(),
                                    chapter[index].chapterName.toString(),
                                    chapter[index].quesNum!.toInt(),
                                    chapter[index].quesTime!.toInt());
                              }),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: LinearProgressIndicator(
                                  color: Colors.green,
                                  value: chapter[index].progress! / 100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ));
                },
              ));
  }
}
