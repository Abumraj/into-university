import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/departmentModel.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/models/level.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';
import '../widgets/hexColor.dart';
import '../widgets/theme_helper.dart';
import 'coursesRegistration.dart';

class StalHome extends StatefulWidget {
  @override
  _StalHomeState createState() => _StalHomeState();
}

class _StalHomeState extends State<StalHome> {
  List<Faculty> faculty = <Faculty>[];
  List<Department> department = <Department>[];
  List<CourseLevel> courseLevel = <CourseLevel>[];
  List<DropdownMenuItem<int>> facultyDropDown = <DropdownMenuItem<int>>[];
  List<DropdownMenuItem<int>> courseLevelDropDown = <DropdownMenuItem<int>>[];
  List<DropdownMenuItem<int>> departmentDropDown = <DropdownMenuItem<int>>[];
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  var _currentFaculty;
  var _currentDepartment;
  var _currentCourseLevel;
  int visible = 3;
  int _semester = 1;
  bool isLoading = false;

  @override
  void initState() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    visible = 3;
    _facultyList();
    super.initState();
  }

  _facultyList() async {
    setState(() {
      isLoading = true;
    });
    List<Faculty> data = await _apiRepository.getFaculty();
    setState(() {
      isLoading = false;
    });
    setState(() {
      faculty = data;
      faculty.reversed;
      facultyDropDown = getFacultyDropDown();
      _currentFaculty = faculty[0].facultyId;
    });
  }

  _courseLevelList() async {
    setState(() {
      isLoading = true;
    });
    List<CourseLevel> data = await _apiRepository.getCourseLevel();
    setState(() {
      isLoading = false;
    });
    setState(() {
      courseLevel = data;
      courseLevelDropDown = getCourseLevelDropDown();
      _currentCourseLevel = courseLevel[0].level;
    });
  }

  departmentList(facultyId) async {
    List<Department> data = await _apiRepository.getDepartment(facultyId);
    setState(() {
      department = data;
      // department.reversed;
      departmentDropDown = getDepartmentDropDown();
      _currentDepartment = department[0].departmentId;
    });
  }

  changeSelectedFaculty(selectedFaculty) async {
    setState(() {
      _currentFaculty = selectedFaculty;
      visible = 2;
    });
    departmentList(_currentFaculty);
  }

  changeSelectedLevel(selectedFaculty) async {
    setState(() {
      _currentCourseLevel = selectedFaculty;
      visible = -1;
    });
  }

  changeSelectedDepartment(selectedDepartment) {
    setState(() {
      _currentDepartment = selectedDepartment;
      visible = 1;
    });
    _courseLevelList();
  }

  void secondSelected(value) {
    setState(() {
      _semester = value;
      visible = 0;
    });
  }

  List<DropdownMenuItem<int>> getFacultyDropDown() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < faculty.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(
                  faculty[i].facultyName.toString(),
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                value: faculty[i].facultyId));
      });
    }
    return items;
  }

  List<DropdownMenuItem<int>> getCourseLevelDropDown() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < courseLevel.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(
                  courseLevel[i].name.toString(),
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                value: courseLevel[i].level));
      });
    }
    return items;
  }

  List<DropdownMenuItem<int>> getDepartmentDropDown() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < department.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(
                  department[i].departmentName.toString(),
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                value: department[i].departmentId));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Department Selection"),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.purple,
        //brightness: Brightness.li,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 1)),
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: "Select your Faculty",
                      labelText: "Faculty",
                      labelStyle: TextStyle(color: Colors.purple),
                      // icon: Icon(
                      //   Icons.factory_outlined,
                      //   color: Colors.purple,
                      //   size: 40,
                      // ),

                      iconColor: Colors.purple,
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                      constraints: BoxConstraints(
                          maxHeight: 50.0, minWidth: 200.0, maxWidth: 310),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2.0,
                              style: BorderStyle.solid)),
                    ),
                    items: facultyDropDown,
                    onChanged: changeSelectedFaculty,
                    hint: Text("Select your faculty"),
                    value: _currentFaculty,
                  ),
                  visible < 3
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: "Select your Department",
                            labelText: "Department",
                            labelStyle: TextStyle(color: Colors.purple),
                            // icon: Icon(
                            //   Icons.house_rounded,
                            //   color: Colors.purple,
                            //   size: 40,
                            // ),
                            iconColor: Colors.purple,
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                            constraints: BoxConstraints(
                                maxHeight: 50.0,
                                minWidth: 200.0,
                                maxWidth: 310),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                          items: departmentDropDown,
                          onChanged: changeSelectedDepartment,
                          hint: Text("Select your Department"),
                          value: _currentDepartment,
                        )
                      : Container(),
                  visible < 2
                      ? DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            hintText: "Select Semester",
                            labelText: "Semester",
                            labelStyle: TextStyle(color: Colors.purple),
                            // icon: Icon(
                            //   Icons.segment_sharp,
                            //   color: Colors.purple,
                            //   size: 40,
                            // ),
                            iconColor: Colors.purple,
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                            constraints: BoxConstraints(
                                maxHeight: 50.0,
                                minWidth: 200.0,
                                maxWidth: 310),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 1,
                              child: Center(
                                child: Text(
                                  "First Semester",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DropdownMenuItem<int>(
                              value: 2,
                              child: Center(
                                child: Text(
                                  "Second Semester",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) => secondSelected(value),
                          hint: Text(
                            "Select Semester",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                          value: _semester,
                        )
                      : Container(),
                  visible < 1
                      ? DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            hintText: "Select Course Level",
                            labelText: "Level",
                            labelStyle: TextStyle(color: Colors.purple),
                            // icon: Icon(
                            //   Icons.height_sharp,
                            //   color: Colors.purple,
                            //   size: 40,
                            // ),
                            iconColor: Colors.purple,
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                            constraints: BoxConstraints(
                                maxHeight: 50.0,
                                minWidth: 200.0,
                                maxWidth: 310),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                          ),
                          items: courseLevelDropDown,
                          onChanged: changeSelectedLevel,
                          hint: Text(
                            "Course Level",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                          value: _currentCourseLevel,
                        )
                      : Container(),
                  visible < 0
                      ? Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple,
                                  offset: Offset(0, 4),
                                  blurRadius: 5.0)
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [
                                HexColor("#DC54FE"),
                                HexColor("#8A02AE"),
                              ],
                            ),
                            color: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Get.to(CourseReg(
                                  departmentId: _currentDepartment.toInt(),
                                  semester: _semester.toInt(),
                                  level: _currentCourseLevel.toInt(),
                                ));
                              }))
                      : Container()
                ],
              ),
            ),
    );
  }
}
