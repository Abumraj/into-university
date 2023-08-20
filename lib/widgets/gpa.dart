import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/widgets/gparesult.dart';
import 'dart:async';

import 'package:uniapp/widgets/theme_helper.dart';

class GPAcalc extends StatefulWidget {
  final int n;
  final double gpg;

  GPAcalc(this.n, this.gpg);

  @override
  GPAcalcstate createState() => new GPAcalcstate();
}

class GPAcalcstate extends State<GPAcalc> {
  List<String> _items = ['A', 'B', 'C', 'D', 'E', 'F'].toList();
  List<String> _itemsCp = ['1', '2', '3', '4', '5', '6'].toList();
  var dataRow = <DataRow>[];

  var _selection;
  var _selectionCp;
  var list;

  @override
  void initState() {
    super.initState();
    _selection = []..length = widget.n;
    _selectionCp = []..length = widget.n;
    list = new List<int>.generate(widget.n, (i) => i);
    // addMoreTableRow();
  }

  @override
  Widget build(BuildContext context) {
    int sogxc = 0, soc = 0;
    var textFields = <Widget>[];
    bool safeToNavigate = true;
    textFields.add(
      new Row(children: [
        Row(
          children: [
            new Padding(
              padding: new EdgeInsets.only(top: 50.0, left: 20),
            ),
          ],
        ),
        new Column(children: [
          new Text(
            "COURSECODE",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Colors.purple),
          ),
        ]),
        new Padding(
          padding: new EdgeInsets.only(left: 50.0),
        ),
        new Column(children: [
          new Text(
            "GRADE",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Colors.purple),
          ),
        ]),
        new Padding(
          padding: new EdgeInsets.only(left: 57.0),
        ),
        new Column(
          children: [
            new Text(
              "CREDITS",
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Colors.purple),
            ),
          ],
        ),
        new Padding(
          padding: new EdgeInsets.only(bottom: 25.0),
        ),
      ]),
    );
    list.forEach((i) {
      textFields.add(
        new Column(
          children: [
            new Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextField(
                    decoration: ThemeHelper().textInputDecoration("course"),
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    style: new TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButtonFormField<String>(
                    decoration: ThemeHelper().textInputDecoration("grade"),
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                    hint: new Text(
                      "grade",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.normal),
                    ),
                    value: _selection[i],
                    items: _items.map((item) {
                      return new DropdownMenuItem<String>(
                        value: item,
                        child: Badge(
                          toAnimate: true,
                          shape: BadgeShape.square,
                          badgeColor: item == 'A'
                              ? Colors.green
                              : item == 'B'
                                  ? Colors.purple
                                  : item == 'C'
                                      ? Colors.yellow
                                      : item == 'D'
                                          ? Colors.pink
                                          : item == 'E'
                                              ? Colors.redAccent
                                              : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          badgeContent: Text(item,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                    onChanged: (s) {
                      setState(() {
                        _selection[i] = s;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButtonFormField<String>(
                    decoration: ThemeHelper().textInputDecoration("unit"),
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                    hint: new Text(
                      "Unit",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.normal),
                    ),
                    items: _itemsCp.map((String items) {
                      return new DropdownMenuItem<String>(
                        value: items,
                        child: Badge(
                          toAnimate: true,
                          shape: BadgeShape.square,
                          badgeColor: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                          badgeContent: Text(items,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                    value: _selectionCp[i],
                    onChanged: (s) {
                      setState(() {
                        _selectionCp[i] = s;
                      });
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
            ]),
          ],
        ),
      );
    });
    double res = 0.0;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GPA calculator"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: new Container(
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.transparent, width: 1.0)),
          child: Container(
            child: ListView(
              children: textFields,
            ),
          )),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Calculate',
        backgroundColor: Colors.purple,
        child: new Icon(Icons.calculate_sharp),
        onPressed: () {
          for (int i = 0; i < widget.n; i++) {
            if (_selectionCp[i] == null) {
              safeToNavigate = false;
              continue;
            }
            if (_selection[i] == null) {
              safeToNavigate = false;
              continue;
            }
            int r = int.parse(_selectionCp[i]);
            int gp = calculate(_selection[i]);
            int cp = r;
            int gxc = gp * cp;
            sogxc += gxc;
            soc += cp;
          }
          res = sogxc / soc;
          var gp = res * widget.gpg;
          gp = gp / 5;
          var status = (gp / widget.gpg) * 100;
          if (safeToNavigate)
            Get.to(ScorePage(gp, status));
          else {
            alert();
          }
        },
      ),
    );
  }

  int calculate(var a) {
    if (a == "A") return 5;
    if (a == "B") return 4;
    if (a == "C") return 3;
    if (a == "D") return 2;
    if (a == "E") return 1;
    if (a == "F") return 0;
    return 0;
  }

  Future<Null> alert() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Rewind and remember'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You must select grade and unit for every course'),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('Try Again'),
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
