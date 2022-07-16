import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html_unescape/html_unescape.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/screens/mainscreen.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question>? questions;
  final Map<int, dynamic>? answers;

  const CheckAnswersPage(
      {Key? key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            itemCount: questions!.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions!.length) {
      return RaisedButton(
        child: Text("Done"),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => MainScreen()));
        },
      );
    }
    Question question = questions![index];
    bool correct = question.correctAnswer == answers![index];
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
              HtmlUnescape().convert("${answers![index]}"),
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
                      TextSpan(text: "Answer: "),
                      TextSpan(
                          text: HtmlUnescape().convert(question.correctAnswer),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  ),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Solution: "),
                      TextSpan(
                          text: HtmlUnescape().convert(question.solution != null
                              ? question.solution
                              : "Solution not available for this question"),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
