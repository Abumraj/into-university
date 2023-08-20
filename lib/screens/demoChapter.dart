import 'package:flutter/material.dart';
import 'package:uniapp/screens/quizPage.dart';

import '../entities.dart';

class QuizOptionsDialog extends StatefulWidget {
  final List<Question>? questions;
  final regCourse;
  final chapterName;
  final quesNum;
  final quesTime;
  final courseId;
  final chapterId;
  const QuizOptionsDialog({
    Key? key,
    @required this.questions,
    @required this.regCourse,
    @required this.quesNum,
    @required this.quesTime,
    @required this.chapterName,
    required this.courseId,
    required this.chapterId,
  }) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.regCourse +
            ":" +
            widget.chapterName.toString().toUpperCase()),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                widget.quesTime > 0
                    ? "You have " +
                        widget.quesTime.toString() +
                        " mins to answer " +
                        widget.quesNum.toString() +
                        " Questions"
                    : "You are about to practice " + widget.chapterName,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    elevation: 0.2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "${widget.chapterName}".toLowerCase() == "test"
                        ? "Start test".toUpperCase()
                        : "${widget.chapterName}".toLowerCase() == "exam"
                            ? "Start Exam".toUpperCase()
                            : "Start to practice".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  widget.questions!.length >= widget.quesNum
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => QuizPage(
                                  questions: widget.questions!,
                                  regCourse: widget.regCourse,
                                  chapterName: widget.chapterName,
                                  courseId: widget.courseId,
                                  chapterId: widget.chapterId,
                                  quesNum: widget.quesNum,
                                  quesTime: widget.quesTime)))
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              title: new Text(
                                "There is currently no question associated with this chapter or the course is probably not CBT based. ",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15.00,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
