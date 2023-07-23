import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/models/studentType.dart';
import 'package:uniapp/screens/ForgotPassword.dart';
import 'package:uniapp/screens/home.dart';
import 'package:uniapp/screens/signUp.dart';
import 'package:uniapp/widgets/header_widget.dart';
import 'package:uniapp/widgets/hexColor.dart';
import 'package:uniapp/widgets/theme_helper.dart';
import '../Services/uapi.dart';

class Login extends StatefulWidget {
  final String? fcmToken;

  const Login({required this.fcmToken});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  List<StudentType>? studentType = <StudentType>[];
  List<DropdownMenuItem<String>> studentTypeDropDown =
      <DropdownMenuItem<String>>[];
  var _currentStudent;
  String? userType;
  late String token;
  bool loading = false;
  bool hidePass = true;
  bool isUserLoggedIn = false;
  String? school;
  String? program;
  void initState() {
    _getSchool();

    super.initState();
  }

  _getSchool() async {
    await Constants.getUserSchoolSharedPreference().then((value) {
      school = value.toString();
    });
    await Constants.getUserProgramSharedPreference().then((value) {
      program = value.toString();
      if (program != "uni") {
        setState(() {
          userType = "remedial";
        });
      }
      _getStudentType();
    });
  }

  _getStudentType() async {
    List<StudentType>? data = await Uapi.getStudentType(school!);
    setState(() {
      studentType = data;
      studentTypeDropDown = getFacultyDropDown();
      _currentStudent = studentType![0].type;
    });
  }

  changeSelectedFaculty(var selectedFaculty) async {
    setState(() {
      _currentStudent = selectedFaculty;
      userType = selectedFaculty;
    });
  }

  List<DropdownMenuItem<String>> getFacultyDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < studentType!.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                child: Text(
                  studentType![i].name.toString(),
                  style: TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                value: studentType![i].type.toString()));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.person), //let's create a common header widget
            ),
            SafeArea(
                child: !loading
                    ? Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        margin: EdgeInsets.fromLTRB(
                            20, 10, 20, 10), // This will be the login form
                        child: Column(
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Signin into your account',
                              style: TextStyle(color: Colors.purple),
                            ),
                            SizedBox(height: 30.0),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: _emailTextController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration(
                                                "E-mail address",
                                                "Enter your email"),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (val) {
                                          // ignore: prefer_is_not_empty
                                          if (!(val!.isEmpty) &&
                                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                  .hasMatch(val)) {
                                            return "Enter a valid email address";
                                          }
                                          return null;
                                        },
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: 30.0),
                                    Container(
                                      child: ListTile(
                                          title: TextFormField(
                                            controller: _passwordTextController,
                                            //obscureText: true,
                                            decoration: ThemeHelper()
                                                .textInputDecoration(
                                                    "Password*",
                                                    "Enter your password"),
                                            obscureText: hidePass,
                                            // ignore: missing_return
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Password is required";
                                              } else if (value.length < 6) {
                                                return "the password has to be at least 6 characters long";
                                              } else
                                                return null;
                                            },
                                          ),
                                          trailing: IconButton(
                                              color: Colors.purple,
                                              icon: Icon(
                                                Icons.remove_red_eye,
                                              ),
                                              onPressed: () {
                                                if (hidePass) {
                                                  setState(() {
                                                    hidePass = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    hidePass = true;
                                                  });
                                                }
                                              })),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: 15.0),
                                    SizedBox(height: 15.0),
                                    program == "uni"
                                        ? Container(
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: ThemeHelper()
                                                  .textInputDecoration(
                                                      "Select Student Type"),
                                              items: studentTypeDropDown,
                                              onChanged: changeSelectedFaculty,
                                              value: _currentStudent,
                                              validator: (userType) {
                                                if (userType!.isEmpty) {
                                                  return "Student Type is required";
                                                } else
                                                  return null;
                                              },
                                              hint: Text(
                                                "Select Student Type",
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 0, 10, 20),
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(ForgotPassword());
                                        },
                                        child: Text(
                                          "Forgot your password?",
                                          style: TextStyle(
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: ThemeHelper()
                                          .buttonBoxDecoration(context),
                                      child: ElevatedButton(
                                        style: ThemeHelper().buttonStyle(),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Text(
                                            'Sign In'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          userLogin();
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 20, 10, 20),
                                      //child: Text('Don\'t have an account? Create'),
                                      child: Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "Don\'t have an account? "),
                                        TextSpan(
                                          text: 'Create',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(() => SignUp());
                                            },
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#8A02AE")),
                                        ),
                                      ])),
                                    ),
                                  ],
                                )),
                          ],
                        ))
                    : Visibility(
                        visible: loading == true,
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.purple),
                            ),
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }

  void secondSelected(value) {
    if (program == "uni") {
      setState(() {
        userType = value;
      });
    } else {
      setState(() {
        userType = "remedial";
      });
    }
  }

  Future userLogin() async {
    FormState? formState = _formKey.currentState;
    // Getting value from Controller
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    // Store all data with Param Name.
    var data = {
      'email': email,
      'password': password,
      'fcmToken': widget.fcmToken
    };
    Constants.saveUserTypeSharedPreference(userType!);
    for (var i = 0; i < studentType!.length; i++) {
      if (userType == studentType![i].type) {
        Constants.saveFirebaseTokenLoggedInSharedPreference(
            studentType![i].paymentModel!);
      }
    }

    Constants.saveUserMailSharedPreference(email);

    if (formState!.validate()) {
      // Showing CircularProgressIndicator.
      setState(() {
        loading = true;
      });

      // SERVER LOGIN API URL
      var url = "$school/$userType/login";
      Dio dio = Dio();
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }),
      );
      var result = response.data;

      var message = result["access_token"];

      if (message != null) {
        Constants.saveUserTokenSharedPreference(message);
        setState(() {
          token = message;
          Constants.saveUserLoggedInSharedPreference(true);
        });
        Get.offAll(() => Home());
      } else {
        setState(() {
          loading = false;
        });
        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: Border(),
              title: new Text(
                response.data['info'],
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 20.00,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
