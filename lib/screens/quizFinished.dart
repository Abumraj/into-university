// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/screens/home.dart';
import '../entities.dart';
import 'checkAnswer.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic>? answers;
  final String? coursecode;
  final String? chapterName;
  final chapterId;
  final courseId;

  QuizFinishedPage(
      {Key? key,
      required this.questions,
      this.answers,
      this.chapterName,
      this.coursecode,
      this.chapterId,
      this.courseId})
      : super(key: key);

  @override
  _QuizFinishedPageState createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {
  int correct = 0;
  int percent = 0;
  saveBot() async {
    widget.answers!.forEach((index, value) {
      if (this.widget.questions[index].correctAnswer == value) {
        ObjectBox.passedQuestion(this.widget.questions[index].id);
        correct++;
      }
      percent = (correct / widget.questions.length * 100).ceil();
    });
    await ObjectBox.saveHighScore(widget.coursecode.toString(),
        widget.chapterName.toString(), percent.toString());
    await ObjectBox.courseProgress(widget.courseId).then((value) {
      ObjectBox.updateCourseProgress(value.toInt(), widget.courseId);
    });
    await ObjectBox.chapterProgress(widget.chapterId).then((value) {
      ObjectBox.updateChapterProgress(value.toInt(), widget.chapterId);
    });
  }

  @override
  void initState() {
    saveBot();
    super.initState();
  }

  final TextStyle titleStyle = TextStyle(
      color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
  final TextStyle trailingStyle = TextStyle(
      color: Colors.purple, fontSize: 20.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Results'),
        backgroundColor: Colors.purple,
        elevation: 0.5,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.purpleAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  title: Text("Total Questions", style: titleStyle),
                  trailing:
                      Text("${widget.questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  title: Text("Score", style: titleStyle),
                  trailing: Text("$percent%", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Correct Answers", style: titleStyle),
                  subtitle: Text("$correct/${widget.questions.length}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("Comment", style: titleStyle),
                    ),
                    subtitle: Text(
                      percent > 69.9
                          ? "Excellent! You have done a great job. Try to achieve similar result with other chapters."
                          : percent > 59.9
                              ? "Very Good. You are almost there. Check out your mistakes and try again."
                              : percent > 49.9
                                  ? "Good performance. Re-watch the video tutorial and check the solution manual for better performance."
                                  : percent > 44.9
                                      ? "Fair performance. Chat with your tutor for more guidiance on this topic"
                                      : "Poor Performance. Re-take the lessons on this topic and chat with your tutor for support.",
                      style: context.textTheme.bodyText2,
                    )),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                    ),
                    child: Text(
                      "Goto Home",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Get.offAll(Home()),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                    ),
                    child: Text(
                      "Check Solutions",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: widget.questions,
                                answers: widget.answers,
                              )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
