import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/uapi.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../widgets/introvideopopup.dart';
import 'checkout.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CourseReg extends StatefulWidget {
  final int departmentId;
  final int semester;
  final int level;
  CourseReg(
      {required this.departmentId,
      required this.semester,
      required this.level});
  @override
  _CourseRegState createState() => _CourseRegState();
}

class _CourseRegState extends State<CourseReg> {
  // CourseRegController _controller = Get.put(CourseRegController());
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  late List<DepartCourse> selectedCourses;
  List<DepartCourse> _departCourse = [];

  String? message;
  bool isLoading = true;
  @override
  void initState() {
    _loadDepartCourse();
    selectedCourses = [];

    super.initState();
  }

  _loadDepartCourse() async {
    final result = await _apiRepository.getDepartCourses(
        widget.departmentId, widget.semester, widget.level);
    setState(() {
      isLoading = false;
      _departCourse = result;
    });
  }

  _emptyCartList() async {
    await _apiRepository.emptyCourseCart().then((value) {
      setState(() {
        message = value.toString();
      });
    });
  }

  onSelectedRow(bool selected, DepartCourse course) async {
    String? message;
    if (selected) {
      //_addToCartList(course.courseId!, course.coursecode!, course.coursePrice);
      await _apiRepository
          .addToCart(course.courseId!, course.coursecode!, course.coursePrice!)
          .then((value) {
        setState(() {
          message = value.toString();
        });
      });
      if (message != null) {
        setState(() {
          selectedCourses.add(course);
        });
        Get.snackbar(course.coursecode!, message!,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.purple,
            ),
            duration: Duration(seconds: 3));
      }
    } else {
      await _apiRepository.deleteACourse(course.coursecode!).then((value) {
        setState(() {
          message = value.toString();
        });
      });
      if (message != null) {
        setState(() {
          selectedCourses.remove(course);
        });
      }
      Get.snackbar(course.coursecode!, message!,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.purple,
          ),
          duration: Duration(seconds: 3));
    }
    // Get.snackbar("Shopping Cart", message!, duration: Duration(seconds: 1));
  }

  deleteSelected() {
    if (selectedCourses.isNotEmpty) {
      _emptyCartList();
      if (message != null) {
        setState(() {
          List<DepartCourse> temp = [];
          temp.addAll(selectedCourses);
          for (DepartCourse course in temp) {
            _departCourse.remove(course);
            selectedCourses.remove(course);
          }
        });
      }
    }
    Get.snackbar("All Courses", message!,
        backgroundColor: Colors.black,
        colorText: Colors.purple,
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.purple,
        ),
        duration: Duration(seconds: 3));
    _loadDepartCourse();
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
        dividerThickness: 1.5,
        columnSpacing: 36,
        showCheckboxColumn: true,
        showBottomBorder: true,
        dataTextStyle:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(
            label: Expanded(
              child: Text(
                "COURSE",
              ),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text("PREVIEW"),
            numeric: false,
          ),
          DataColumn(
            label: Text("UNIT"),
            numeric: true,
          ),
          DataColumn(
            label: Text("PRICE"),
            numeric: true,
          ),
        ],
        rows: _departCourse
            .map(
              (course) => DataRow(
                  selected: selectedCourses.contains(course),
                  onSelectChanged: (b) {
                    onSelectedRow(b!, course);
                  },
                  cells: [
                    DataCell(
                      Text(course.coursecode.toString()),
                    ),
                    DataCell(IconButton(
                        icon: Icon(
                          Icons.preview,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          showDownloadPopup(context,
                              videoUrl: course.introUrl,
                              description: course.courseName);
                        })),
                    DataCell(
                      Center(
                        child: Badge(
                          toAnimate: true,
                          shape: BadgeShape.square,
                          badgeColor: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                          badgeContent: Text("${course.courseUnit}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                          child: Text(course.coursePrice! < 1
                              ? "FREE"
                              : "₦${course.coursePrice}")),
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
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
              '15% Off',
              textStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0),
              duration: const Duration(milliseconds: 5000),

              // duration: Duration(seconds: 10),
            ),
            // speed: const Duration(milliseconds: 2000),
            FadeAnimatedText(
              'when you spend above ',
              textStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              duration: const Duration(milliseconds: 3000),

              // duration: Duration(seconds: 10),
            ),
            FadeAnimatedText(
              '₦5000',
              textStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0),
              duration: const Duration(milliseconds: 5000),
            ),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutPage(),
                    ),
                  );
                }),
                child: Badge(
                  badgeContent: Text(
                    "${selectedCourses.length}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
      body: _departCourse.isEmpty && !isLoading
          ? Container(
              decoration: new BoxDecoration(
                  border:
                      new Border.all(color: Colors.transparent, width: 25.0),
                  color: Colors.transparent),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sorry, there is currently no tutorial for your department. Click below to make tutorial request",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Uapi.joinTelegramGroupChat(
                            "https://docs.google.com/forms/d/e/1FAIpQLSfNfTMGSS7mEMhOWoP-W00kR-yccwq8FMEEaBVtj5VvG5O-1Q/viewform?usp=pp_url",
                            false);
                      },
                      child: const Text('Make Tutorial Request'),
                    ),
                  ],
                ),
              ),
            )
          : isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TyperAnimatedText(
                            'COURSE REGISTRATION PER SEMESTER OR PER 4 MONTHS',
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            speed: Duration(milliseconds: 100)
                            // duration: Duration(seconds: 10),
                            ),
                        // speed: const Duration(milliseconds: 2000),
                        // FadeAnimatedText(
                        //   'OR PER 4 MONTHS',
                        //   textStyle: TextStyle(
                        //       color: Colors.red,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 16.0),
                        //   // duration: Duration(seconds: 10),
                        // ),

                        // speed: const Duration(milliseconds: 2000),
                      ],
                      totalRepeatCount: 4,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    Expanded(
                      child: dataBody(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 1.0, top: 20.0, right: 5.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.purple,
                                elevation: 0.2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            child: Text(
                              'View Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.0, top: 20.0, right: 1.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.purple,
                                elevation: 0.2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            child: Text(
                              'DELETE ALL',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: selectedCourses.isEmpty
                                ? () {}
                                : () {
                                    deleteSelected();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
