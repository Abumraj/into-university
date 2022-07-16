// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/screens/quizFinished.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final regCourse;
  final chapterName;
  final quesNum;
  final quesTime;

  const QuizPage(
      {Key? key,
      required this.questions,
      required this.regCourse,
      required this.quesNum,
      required this.quesTime,
      required this.chapterName})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);
  late AnimationController _controller;
  int levelClock = 0;
  int _currentIndex = 0;
  int maxQuest = 0;
  int quesTime = 0;
  //int _duration;
  final List<Question> shuffleQuestion = [];
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController _germanTextEditor = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    maxQuest = widget.quesNum;
    levelClock = widget.quesTime * 60;
    if (widget.questions.length > 0) {
      for (var i = 0; shuffleQuestion.length < maxQuest; i++) {
        widget.questions.shuffle();
        shuffleQuestion.add(widget.questions[i]);
      }
    }
    determineTime();
  }

  determineTime() {
    if (widget.quesTime > 0) {
      _controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds: levelClock -
                  1) // gameData.levelClock is a user entered number elsewhere in the applciation
          );

      _controller.forward().whenComplete(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => QuizFinishedPage(
                questions: shuffleQuestion,
                answers: _answers,
                chapterName: widget.chapterName,
                coursecode: widget.regCourse)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Question question = shuffleQuestion[_currentIndex];
    final List<dynamic> options = [
      question.option2,
      question.option3,
      question.option4
    ];
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop(),
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          actions: <Widget>[
            levelClock > 0
                ? Countdown(
                    animation: StepTween(
                      begin: levelClock - 1, // THIS IS A USER ENTERED NUMBER
                      end: 0,
                    ).animate(_controller),
                  )
                : Container(),
            new RaisedButton(
              child: Text("submit"),
              onPressed: _nextSubmit,
              color: Colors.green,
            ),
          ],
          elevation: 0.5,
        ),
        body: Stack(
          children: <Widget>[
            ClipRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      widget.regCourse + ':' + widget.chapterName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}" + "/" + "$maxQuest"),
                        maxRadius: 20,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              shuffleQuestion[_currentIndex].question!),
                          softWrap: true,
                          style: _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: options.length > 1
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...options.map((option) => RadioListTile(
                                    title:
                                        Text(HtmlUnescape().convert("$option")),
                                    groupValue: _answers[_currentIndex],
                                    value: options,
                                    onChanged: (value) {
                                      setState(() {
                                        _answers[_currentIndex] = option;
                                      });
                                    },
                                  )),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: _germanTextEditor,
                                onEditingComplete: () {
                                  setState(() {
                                    _answers[_currentIndex] =
                                        _germanTextEditor.text;
                                  });
                                },
                                decoration: InputDecoration(
                                    labelText: "Type Your Answer Here",
                                    labelStyle: TextStyle(
                                        color: Colors.purple, fontSize: 12)),
                              )
                            ],
                          ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: RaisedButton(
                            child: Text("Previous"),
                            onPressed: _previous,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                            child: Text("Next"),
                            onPressed: _next,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _next() {
    if (_currentIndex < (maxQuest - 1)) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previous() {
    if (_currentIndex > 0 &&
        (_currentIndex < (maxQuest - 1) || _currentIndex == (maxQuest - 1))) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  // void onTimeUp() {
  //   if (_controller.isCompleted) {
  //     _controller.dispose();
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (_) =>
  //             QuizFinishedPage(questions: shuffleQuestion, answers: _answers)));
  //   }
  // }

  void _nextSubmit() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => QuizFinishedPage(
            questions: shuffleQuestion,
            answers: _answers,
            chapterName: widget.chapterName,
            coursecode: widget.regCourse)));
  }

  _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 30,
        color: animation.value > (0.25 * animation.value)
            ? Colors.blue
            : Colors.red,
      ),
    );
  }
}
