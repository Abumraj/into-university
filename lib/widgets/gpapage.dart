import 'package:flutter/material.dart';
import 'package:uniapp/widgets/gpa.dart';
import 'dart:async';

class GPA extends StatefulWidget {
  @override
  GPAState createState() => new GPAState();
}

class GPAState extends State<GPA> {
  TextEditingController controller = new TextEditingController();
  int n = 0;
  List<String> _items = ['4.0', '5.0', '6.0', '7.0', '8.0', '9.0'].toList();
  var _selection;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GPA calculator"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.transparent, width: 25.0),
            color: Colors.transparent),
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new DropdownButton<String>(
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
                hint: new Text(
                  "Select Grade Scale",
                  style: TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.normal),
                ),
                value: _selection,
                items: _items.map((String item) {
                  return new DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.center,
                    value: item,
                    child: new Text(
                      item,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
                onChanged: (s) {
                  setState(() {
                    _selection = s;
                  });
                },
              ),
              new TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: new InputDecoration(
                    fillColor: Colors.deepOrangeAccent,
                    hintText: "Number of courses ",
                    hintStyle: new TextStyle(color: Colors.purple)),
                keyboardType: TextInputType.number,
                controller: controller,
                onChanged: (String str) {
                  setState(() {
                    n = int.parse(controller.text);
                  });
                },
              ),
              new IconButton(
                icon: new Icon(
                  Icons.arrow_forward,
                  color: Colors.purple,
                ),
                onPressed: () {
                  if (n > 0) {
                    int pass = n;
                    double gpg = double.parse(_selection);
                    n = 0;
                    controller.text = "";
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new GPAcalc(pass, gpg)));
                  } else {
                    controller.text = "";
                    alert();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> alert() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('rewind and regret fool !'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You think you are smart?.'),
                new Text('Guess what... you are not.'),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
