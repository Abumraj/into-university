import 'package:flutter/material.dart';
import 'package:uniapp/Services/api.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/screens/mainscreen.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';

class CheckoutMethodBank extends StatefulWidget {
  final amount;
  CheckoutMethodBank({this.amount});
  @override
  _CheckoutMethodBankState createState() => _CheckoutMethodBankState();
}

class _CheckoutMethodBankState extends State<CheckoutMethodBank> {
  // bool isGeneratingCode;
  // String email;
  // String token;
  // bool done;
  // String change = "Click to Fetch Questions";
  // String userType;
  // int koboAmount;
  // bool fetching = false;
  // DbHelper _dbHelper = DbHelper();
  // List<RegCourse> course;
  // Future<List<dynamic>> regCourse;
  // List<Chapter> courses;
  // List<dynamic> regCourses;
  // int counter = 0;
  // List<Question> question;
  // List<dynamic> quest;
  // String authorisationUrl;
  // @override
  // void initState() {
  //   isGeneratingCode = true;
  //   done = false;
  //   koboAmount = widget.amount * 100;
  //   _getUserTypeIjjnState();
  //   super.initState();
  // }

  // _getUserTypeIjjnState() async {
  //   await Constants.getUserMailSharedPreference().then((value) {
  //     setState(() {
  //       email = value;
  //     });
  //   });
  //   await Constants.getUserTokenSharedPreference().then((value) {
  //     setState(() {
  //       token = value;
  //     });
  //   });
  //   await Constants.getUserTypeSharedPreference().then((value) {
  //     setState(() {
  //       userType = value;
  //     });
  //   });
  //   await Api.getStaAccessCode(koboAmount, email, userType, token)
  //       .then((value) {
  //     authorisationUrl = value["data"]["authorization_url"];
  //   });
  //   setState(() {
  //     isGeneratingCode = false;
  //   });
  // }

  // Future _loadAndSave() async {
  //   await Api.getRegCourse(userType, token).then((allRegCourse) {
  //     course = allRegCourse;
  //     // print(course[0]);
  //     _dbHelper.truncateTable1().then((value) {
  //       insert(course[0]);
  //     });
  //     Api.getChapter(userType, token).then((value) {
  //       _dbHelper.truncateTable2();
  //       _dbHelper.saveChapter(value);
  //     });
  //     Api.getQuestions(userType, token).then((value) {
  //       _dbHelper.truncateTable3();
  //       _dbHelper.saveQuestion(value);
  //     });
  //   });
  // }

  // insert(RegCourse regCourse) {
  //   _dbHelper.saveRegCourse(regCourse).then((val) {
  //     counter = counter + 1;
  //     if (counter >= course.length) {
  //       return;
  //     }
  //     RegCourse a = course[counter];
  //     insert(a);
  //     print(a);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // appBar: AppBar(
    //   title: Text(
    //     fetching
    //         ? "Fectching Resources"
    //         : done ? "Done" : "Processing Payment",
    //   ),
    //   centerTitle: true,
    //   elevation: 0.0,
    // ),
    // body: isGeneratingCode || fetching
    //     ? Container(
    //         padding: EdgeInsets.all(10),
    //         child: Center(
    //           child: RaisedButton(
    //             color: Colors.purple,
    //             elevation: 0.2,
    //             child: Text(
    //               isGeneratingCode
    //                   ? "Processing.."
    //                   : fetching ? change : done ? "Continue->" : "",
    //               style: TextStyle(
    //                   color: Colors.white, fontWeight: FontWeight.bold),
    //             ),
    //             onPressed: done
    //                 ? () {
    //                     Navigator.of(context).push(MaterialPageRoute(
    //                         builder: (_) => MainScreen()));
    //                   }
    //                 : fetching
    //                     ? () {
    //                         setState(() {
    //                           change = "Fetching Questions";
    //                         });
    //                         _loadAndSave();
    //                       }
    //                     : () {},
    //           ),
    //         ))
    //     : WebView(
    //         initialUrl: authorisationUrl,
    //         javascriptMode: JavascriptMode.unrestricted,
    //         navigationDelegate: (navigation) {
    //           if (navigation.url == "https:") {
    //             setState(() {
    //               fetching = true;
    //             });
    //           }
    //           return NavigationDecision.navigate;
    //         },
    //       ));
  }
}
