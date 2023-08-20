import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html_unescape/html_unescape.dart';
import 'package:uniapp/screens/home.dart';

import '../entities.dart';

class CheckAnswersPage extends StatefulWidget {
  final List<Question>? questions;
  final Map<int, dynamic>? answers;

  const CheckAnswersPage(
      {Key? key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  State<CheckAnswersPage> createState() => _CheckAnswersPageState();
}

class _CheckAnswersPageState extends State<CheckAnswersPage> {
  @override
  void initState() {
    secureScreen();
    super.initState();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text('Check Solution'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.questions!.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == widget.questions!.length) {
      return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.2,
          textStyle: TextStyle(color: Colors.white),
        ),
        child: Text("Done", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Get.offAll(Home());
        },
      );
    }
    Question question = widget.questions![index];
    bool correct = question.correctAnswer == widget.answers![index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.question!),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              HtmlUnescape().convert("${widget.answers![index]}"),
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "Answer: ",
                          style: TextStyle(color: Colors.purple[800])),
                      TextSpan(
                          text: HtmlUnescape().convert(question.correctAnswer!),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  ),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "Solution: ",
                          style: TextStyle(color: Colors.purple[800])),
                      TextSpan(
                          text: HtmlUnescape().convert(
                              question.solution.toString() != "null"
                                  ? question.solution.toString()
                                  : "Solution not available for this question"),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: question.solution.toString() != "null"
                                  ? Colors.purple
                                  : Colors.red))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
