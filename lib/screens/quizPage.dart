import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:uniapp/screens/quizFinished.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../entities.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final regCourse;
  final chapterName;
  final quesNum;
  final quesTime;
  final courseId;
  final chapterId;

  const QuizPage({
    Key? key,
    required this.questions,
    required this.regCourse,
    required this.quesNum,
    required this.quesTime,
    required this.chapterName,
    required this.courseId,
    required this.chapterId,
  }) : super(key: key);

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
  bool isLoading = true;
  final List<Question> shuffleQuestion = [];
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController _germanTextEditor = TextEditingController();

  @override
  void initState() {
    createQuestion();
    disableScreenRecord();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  createQuestion() {
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
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: levelClock > 0
                ? levelClock - 1
                : 3599) // gameData.levelClock is a user entered number elsewhere in the applciation
        );
    // if (levelClock > 0) {
    _controller.forward().whenComplete(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
                questions: shuffleQuestion,
                answers: _answers,
                chapterName: widget.chapterName,
                coursecode: widget.regCourse,
                courseId: widget.courseId,
                chapterId: widget.chapterId,
              )));
    });
    isLoading = false;
  }

  disableScreenRecord() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    Question question = shuffleQuestion[_currentIndex];
    final List<dynamic> options = [
      question.option2,
      question.option3,
      question.option4
    ];
    if (options.length > 0 && options.length != 4) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        actions: <Widget>[
          Countdown(
            animation: StepTween(
              begin: levelClock > 0
                  ? levelClock - 1
                  : 0, // THIS IS A USER ENTERED NUMBER
              end: levelClock > 0 ? 0 : 3599,
            ).animate(_controller),
          ),
          new TextButton(
            child: Text("submit"),
            onPressed: _nextSubmit,
            style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
          ),
        ],
        elevation: 0.5,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.purple,
            ))
          : WillPopScope(
              onWillPop: () async {
                final shouldPop = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Do you want to quit? Your progress will be lost.',
                        style: TextStyle(color: Colors.purple, fontSize: 17),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Quit'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Continue'),
                        ),
                      ],
                    );
                  },
                );
                return shouldPop!;
              },
              child: Stack(
                children: <Widget>[
                  ClipRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
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
                              backgroundColor: Colors.white,
                              child: Text(
                                "${_currentIndex + 1}" + "/" + "$maxQuest",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.purple),
                              ),
                              maxRadius: 18,
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
                                    ...options.map((option) =>
                                        RadioListTile<dynamic>(
                                          enableFeedback: true,
                                          selected: true,
                                          toggleable: true,
                                          activeColor: Colors.purple,
                                          title: Text(HtmlUnescape()
                                              .convert("$option")),
                                          groupValue: _answers[_currentIndex],
                                          value: option,
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
                                              color: Colors.purple,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    elevation: 0.2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  child: Text("Previous",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: _previous,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    elevation: 0.2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  child: Text("Next",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: _next,
                                ),
                              ),
                            )
                          ],
                        ),
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

  void _nextSubmit() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => QuizFinishedPage(
              questions: shuffleQuestion,
              answers: _answers,
              chapterName: widget.chapterName,
              coursecode: widget.regCourse,
              courseId: widget.courseId,
              chapterId: widget.chapterId,
            )));
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

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 30,
        color: animation.value > (0.25 * animation.value)
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}
