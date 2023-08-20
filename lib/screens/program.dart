import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/models/program.dart';
import 'package:uniapp/models/school.dart';
import 'package:uniapp/screens/signUp.dart';
import 'package:uniapp/services/uapi.dart';
import 'package:uniapp/widgets/hexColor.dart';
import 'package:uniapp/widgets/theme_helper.dart';

class Programs extends StatefulWidget {
  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  List<Program>? program = <Program>[];
  List<School> school = <School>[];
  List<DropdownMenuItem<String>> programDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> schoolDropDown = <DropdownMenuItem<String>>[];
  var _currentProgram;
  var _currentSchool;
  late bool done = false;
  @override
  void initState() {
    _getFaculty();
    super.initState();
  }

  _getFaculty() async {
    List<Program>? data = await Uapi.getProgram();
    setState(() {
      program = data!;
      programDropDown = getFacultyDropDown();
      _currentProgram = program![0].programCode!;
    });
  }

  changeSelectedFaculty(var selectedFaculty) async {
    setState(() {
      _currentProgram = selectedFaculty;
    });
    Constants.saveUserProgramSharedPreference(_currentProgram);
    await _getDepatrment(_currentProgram);
  }

  _getDepatrment(_currentProgram) async {
    List<School> data = await Uapi.getSchool(_currentProgram);
    setState(() {
      school = data;
      schoolDropDown = getDepartmentDropDown();
      _currentSchool = school[0].schoolCode!;
    });
  }

  changeSelectedDepartment(var selectedDepartment) async {
    setState(() => _currentSchool = selectedDepartment);
    Constants.saveUserSchoolSharedPreference(_currentSchool);
    school.forEach((element) {
      if (element.schoolCode == _currentSchool) {
        Constants.saveFirebaseTopicByProgramInSharedPreference(
            element.schoolName);
      }
    });
    done = true;
  }

  List<DropdownMenuItem<String>> getFacultyDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < program!.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                child: Text(
                  program![i].programName.toString(),
                  style: TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                value: program![i].programCode.toString()));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDepartmentDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < school.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                child: Text(
                  school[i].schoolName,
                  style: TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                value: school[i].schoolCode));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var dropdownButton = DropdownButtonFormField(
      decoration: InputDecoration(
        hintText: "Select your Program",
        icon: Icon(
          Icons.event,
          color: Colors.purple,
          size: 40,
        ),
        iconColor: Colors.purple,
        contentPadding: EdgeInsets.only(left: 20.0),
        hintStyle: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        constraints:
            BoxConstraints(maxHeight: 50.0, minWidth: 200.0, maxWidth: 310),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.purple, width: 2.0, style: BorderStyle.solid)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.purple, width: 2.0, style: BorderStyle.solid)),
      ),
      items: programDropDown,
      onChanged: changeSelectedFaculty,
      style: TextStyle(color: Colors.purple),
      value: _currentProgram,
    );
    var children2 = <Widget>[
      dropdownButton,
      SizedBox(
        height: 12.0,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: "Select your School/Exam",
            icon: Icon(
              Icons.school_rounded,
              color: Colors.purple,
              size: 40,
            ),
            iconColor: Colors.purple,
            contentPadding: EdgeInsets.only(left: 20.0),
            hintStyle:
                TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
            constraints:
                BoxConstraints(maxHeight: 50.0, minWidth: 200.0, maxWidth: 310),
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
          items: schoolDropDown,
          onChanged: changeSelectedDepartment,
          iconEnabledColor: Colors.purple,
          value: _currentSchool,
        ),
      ),
      SizedBox(
        height: 12.0,
      ),
      done
          ? Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
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
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
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
                    Get.to(() => SignUp());
                  },
                ),
              ),
            )
          : Container()
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          "Program Selection",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                child: Icon(Icons.refresh),
                onTap: () {
                  _getFaculty();
                }),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: children2,
          ),
        ),
      ),
    );
  }
}
