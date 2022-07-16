import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniapp/Services/api.dart';
import 'package:uniapp/Services/serviceImplementation.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/screens/mainscreen.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String title = "Write A Review";
  String? reviewTitle;
  String? reviewDescription;
  String info = "Help us improve our services to you by writing a review";
  late bool isDone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: Text(
                  info,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                prefix: Text(
                  "Title",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
                controller: _titleController,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.purple,
                        style: BorderStyle.solid,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                    shape: BoxShape.rectangle),
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 8.0,
                    fontWeight: FontWeight.normal),
                textCapitalization: TextCapitalization.words,
                enableSuggestions: true,
                maxLength: 90,
                placeholder: "Your title here",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                prefix: Text(
                  "Description",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
                autocorrect: true,
                controller: _descriptionController,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.purple,
                        style: BorderStyle.solid,
                        width: 4.0),
                    borderRadius: BorderRadius.circular(5.0),
                    shape: BoxShape.rectangle),
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 8.0,
                    fontWeight: FontWeight.normal),
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                maxLength: 2000,
                placeholder: "Your description here",
              ),
            ),
            !isDone
                ? RaisedButton(
                    color: Colors.purple,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_titleController.text != null &&
                          _descriptionController.text != null) {
                        Api.writeAreview(
                            _titleController.text, _descriptionController.text);
                        setState(() {
                          title = "Review Submitted";
                          isDone = true;
                        });
                      } else {
                        setState(() {
                          info = "Both Fields Are Required";
                        });
                      }
                    },
                  )
                : RaisedButton(
                    color: Colors.purple,
                    child: Text(
                      "Back Home",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ));
                    })
          ],
        ),
      ),
    );
  }
}
