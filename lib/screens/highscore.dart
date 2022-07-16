import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/highScoreModel.dart';

import '../dbHelper/db.dart';

class CourseProgress extends StatefulWidget {
  final coursecode;
  const CourseProgress({Key? key, this.coursecode}) : super(key: key);

  @override
  State<CourseProgress> createState() => _CourseProgressState();
}

class _CourseProgressState extends State<CourseProgress> {
  List<HighScore> selectedCourses = [];
  DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    load(widget.coursecode);
    super.initState();
  }

  load(String coursecode) {
    loadHighScore(coursecode);
  }

  loadHighScore(String coursecode) async {
    final result = await _dbHelper.getAllHighScore(coursecode);
    print(result.isNotEmpty);
    if (result.isNotEmpty) {
      setState(() {
        selectedCourses = result;
      });
    } else {
      GetSnackBar(
        message: 'You have not started practising this course',
      );
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          // DataColumn(
          //   label: Text("COURSE NAME"),
          //   numeric: false,),
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
              (course) => DataRow(
                  selected: selectedCourses.contains(course),
                  onSelectChanged: (b) {},
                  cells: [
                    // DataCell(
                    //   Text(course.courseName),
                    //   onTap: () {
                    //     print('Selected ${course.courseName}');
                    //   },
                    // ),
                    DataCell(
                      Text(
                        course.chapterName.toString(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                    DataCell(
                      Text(
                        course.score.toString(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                    DataCell(
                      Text(
                        course.score.toString(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
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
