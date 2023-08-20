import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/models/studentType.dart';
import 'package:uniapp/widgets/header_widget.dart';
import 'package:uniapp/widgets/theme_helper.dart';
import '../Services/uapi.dart';
import '../widgets/hexColor.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  List<StudentType>? studentType = <StudentType>[];
  List<DropdownMenuItem<String>> studentTypeDropDown =
      <DropdownMenuItem<String>>[];
  var _currentStudent;

  String? userType;
  String? fcmbToken;
  bool loading = false;
  bool hidePass = true;
  String? school;
  String? program;
  bool checkedValue = false;
  bool checkboxValue = false;
  @override
  void initState() {
    requestPermission();
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

  void requestPermission() async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
      _messaging.getToken().then((value) {
        fcmbToken = value;
      });
      getToken();
    }
  }

  void getToken() async {
    String schoolName = '';
    await FirebaseMessaging.instance.subscribeToTopic('UniApp');
    await Constants.getFirebaseTopicByProgramSharedPreference().then((value) {
      schoolName = value.toString();
    });
    await FirebaseMessaging.instance.subscribeToTopic(schoolName);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            !loading
                ? Container(
                    margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Stack(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                width: 5, color: Colors.white),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 20,
                                                offset: const Offset(5, 5),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "images/uniappLogo.png",
                                            height: 80,
                                            width: 80,
                                          )),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(80, 80, 0, 0),
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colors.grey.shade700,
                                          size: 25.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                    controller: _nameTextController,
                                    decoration: ThemeHelper()
                                        .textInputDecoration('Full Name',
                                            'Enter your full name'),
                                    validator: (value) {
                                      // ignore: prefer_is_not_empty
                                      if ((value!.isEmpty)) {
                                        return "The name field cannot be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                    controller: _emailTextController,
                                    decoration: ThemeHelper()
                                        .textInputDecoration("E-mail address",
                                            "Enter your email"),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      // ignore: prefer_is_not_empty
                                      if ((val!.isEmpty) ||
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                              .hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: ThemeHelper()
                                        .textInputDecoration("Mobile Number",
                                            "Enter your mobile number"),
                                    keyboardType: TextInputType.phone,
                                    validator: (val) {
                                      // ignore: prefer_is_not_empty
                                      if ((val!.isEmpty) ||
                                          !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  child: ListTile(
                                      title: TextFormField(
                                        controller: _passwordTextController,
                                        //obscureText: true,
                                        decoration: ThemeHelper()
                                            .textInputDecoration("Password",
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
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.purple,
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
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  child: ListTile(
                                      title: TextFormField(
                                        controller: _confirmPasswordController,
                                        //obscureText: true,
                                        decoration: ThemeHelper()
                                            .textInputDecoration(
                                                "Confirm Password",
                                                "Re-enter your password"),
                                        obscureText: hidePass,
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Password field is required";
                                          } else if (value.length < 6) {
                                            return "the password has to be at least 6 characters long";
                                          } else if (_passwordTextController
                                                  .text !=
                                              value) {
                                            return "Your password do not match";
                                          } else
                                            return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.purple,
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
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 15.0),
                                program == "uni"
                                    ? Container(
                                        decoration: ThemeHelper()
                                            .inputBoxDecorationShaddow(),
                                        child: DropdownButtonFormField<String>(
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
                                            style:
                                                TextStyle(color: Colors.purple),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                FormField<bool>(
                                  builder: (state) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Checkbox(
                                                value: checkboxValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkboxValue = value!;
                                                    state.didChange(value);
                                                  });
                                                }),
                                            Text(
                                              "I accept all terms and conditions.",
                                              style: TextStyle(
                                                  color: Colors.purple),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            state.errorText ?? '',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).errorColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  validator: (value) {
                                    if (!checkboxValue) {
                                      return 'You need to accept terms and conditions';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        "Register".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      validateFormAndSubmit();
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Already have an account? "),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => Login(
                                                fcmToken: fcmbToken,
                                              ));
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
                  )
          ],
        ),
      ),
    );
  }

  Future validateFormAndSubmit() async {
    FormState? formState = _formKey.currentState;

    String fullName = _nameTextController.text;
    String password = _passwordTextController.text;
    String email = _emailTextController.text;
    String phoneNumber = _phoneNumberController.text;
    dynamic data = {
      'name': fullName,
      'phone': phoneNumber,
      'email': email,
      'password': password,
      'fcmbToken': fcmbToken,
    };

    if (formState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
        Dio dio = Dio();
        String url = "$school/$userType/register";

        var response = await dio.post(
          url,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }),
        );
        var message = response.data;
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
          });

          if (message == 'You have successfully registered') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(
                  fcmToken: fcmbToken,
                ),
              ), //MaterialPageRoute
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text(
                    message,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 10.00,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: new Text("Sorry, An error occurred"),
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
      } catch (e) {}
    }
  }
}
