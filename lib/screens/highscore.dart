import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../dbHelper/db.dart';
import '../entities.dart';

class CourseProgress extends StatefulWidget {
  final coursecode;
  const CourseProgress({Key? key, this.coursecode}) : super(key: key);

  @override
  State<CourseProgress> createState() => _CourseProgressState();
}

class _CourseProgressState extends State<CourseProgress> {
  List<HighScore> selectedCourses = [];

  @override
  void initState() {
    load(widget.coursecode);
    super.initState();
  }

  load(String coursecode) {
    loadHighScore(coursecode);
  }

  loadHighScore(String coursecode) async {
    final result = await ObjectBox.getAllHighScore(coursecode);
    if (result.isNotEmpty) {
      setState(() {
        selectedCourses = result;
      });
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected))
            return Colors.purple.withOpacity(0.3);
          return null; // Use the default value.
        }),
        horizontalMargin: 12,
        dividerThickness: 2.5,
        columnSpacing: 28,
        showCheckboxColumn: false,
        showBottomBorder: true,
        dataTextStyle:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(
            label: Text(
              "S/N",
              style: TextStyle(color: Colors.purple),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              "CHAPTER NAME",
              style: TextStyle(color: Colors.purple),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "SCORE",
              style: TextStyle(color: Colors.purple),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              "GRADE",
              style: TextStyle(color: Colors.purple),
            ),
            numeric: true,
          ),
        ],
        rows: selectedCourses
            .map(
              (course) =>
                  DataRow(selected: selectedCourses.contains(course), cells: [
                DataCell(
                  Text(
                    "${selectedCourses.indexOf(course) + 1}",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                DataCell(
                  Text(
                    course.chapterName.toString(),
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                DataCell(Badge(
                  toAnimate: true,
                  shape: BadgeShape.square,
                  badgeColor: int.parse(course.score!) > 69
                      ? Colors.green
                      : int.parse(course.score!) > 59
                          ? Colors.purple
                          : int.parse(course.score!) > 49
                              ? Colors.yellow
                              : int.parse(course.score!) > 39
                                  ? Colors.redAccent
                                  : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(course.score!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                )),
                DataCell(Badge(
                  toAnimate: true,
                  shape: BadgeShape.square,
                  badgeColor: int.parse(course.score!) > 69
                      ? Colors.green
                      : int.parse(course.score!) > 59
                          ? Colors.purple
                          : int.parse(course.score!) > 49
                              ? Colors.yellow
                              : int.parse(course.score!) > 39
                                  ? Colors.redAccent
                                  : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(
                      int.parse(course.score!) > 69
                          ? "A"
                          : int.parse(course.score!) > 59
                              ? "B"
                              : int.parse(course.score!) > 49
                                  ? "C"
                                  : int.parse(course.score!) > 44
                                      ? "D"
                                      : int.parse(course.score!) > 39
                                          ? "E"
                                          : "F",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 1.0,
        title: Text(widget.coursecode),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Center(
              child: Text(
                "${widget.coursecode.toString().toUpperCase()} PROGRESS",
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ),
          Expanded(
            child: dataBody(),
          ),
        ],
      ),
    );
  }
}
