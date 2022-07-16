import 'package:flutter/material.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/screens/quizPage.dart';
import 'package:uniapp/widgets/theme_helper.dart';

class QuizOptionsDialog extends StatefulWidget {
  final List<Question>? questions;
  final regCourse;
  final chapterName;
  final quesNum;
  final quesTime;
  const QuizOptionsDialog(
      {Key? key,
      @required this.questions,
      @required this.regCourse,
      @required this.quesNum,
      @required this.quesTime,
      @required this.chapterName})
      : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Expanded(
          child: Text(widget.regCourse + " : " + widget.chapterName),
        ),
        elevation: 1.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Expanded(
                child: Text(
                  widget.quesTime > 0
                      ? "You have " +
                          widget.quesTime +
                          "mins to answer" +
                          widget.quesNum +
                          "Questions"
                      : "You are about to practice " + widget.chapterName,
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: ElevatedButton(
                style: ThemeHelper().buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    widget.chapterName == "test"
                        ? "Start test".toUpperCase()
                        : widget.chapterName == "exam"
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => QuizPage(
                              questions: widget.questions!,
                              regCourse: widget.regCourse,
                              chapterName: widget.chapterName,
                              quesNum: widget.quesNum,
                              quesTime: widget.quesTime)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
