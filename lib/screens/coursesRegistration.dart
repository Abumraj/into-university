import 'package:badges/badges.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:video_player/video_player.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../widgets/introvideopopup.dart';
import 'checkout.dart';

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

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String? message;
  int _totalPrice = 0;
  @override
  void initState() {
    _loadDepartCourse();
    selectedCourses = [];

    super.initState();
  }

  _loadDepartCourse() async {
    final result = await _apiRepository.getDepartCourses(
        widget.departmentId, widget.semester, widget.level);
    if (result.isNotEmpty) {
      setState(() {
        _departCourse = result;
      });
      print(_departCourse);
    }
  }

  // _addToCartList(courseId, courseCode, coursePrice) async {
  //   await _apiRepository
  //       .addToCart(courseId, courseCode, coursePrice)
  //       .then((value) {
  //     setState(() {
  //       message = value.toString();
  //     });
  //   });
  // }

  // _deleteFromCartList(courseCode) async {
  //   await _apiRepository.deleteACourse(courseCode).then((value) {
  //     setState(() {
  //       message = value.toString();
  //     });
  //   });
  // }

  _emptyCartList() async {
    await _apiRepository.emptyCourseCart().then((value) {
      setState(() {
        message = value.toString();
      });
    });
  }

  // onSelectedAll(bool selected, DepartCourse course) {
  //   if (selected) {
  //     forEach(DepartCourse course) {
  //       _addToCartList(
  //           course.courseId!, course.coursecode!, course.coursePrice);
  //     }
  //     //forEach(selectAll);
  //     //for (int j = 0; j < course.length; j++) {
  //     //       if (result[i].videoName == offResult[j].videoName) {
  //     //         result[i].videoUrl = offResult[j].videoUrl;
  //     //         result[i].thumbUrl = offResult[j].thumbUrl;
  //     //         result[i].status = offResult[j].status;
  //     //       }
  //     //     }

  //     setState(() {
  //       selectedCourses.add(course);
  //       _totalPrice += course.coursePrice;
  //       Get.snackbar("Shopping Cart", message!,
  //           duration: Duration(microseconds: 500));
  //     });
  //   } else {
  //     _deleteFromCartList(course.coursecode);

  //     setState(() {
  //       selectedCourses.remove(course);
  //       _totalPrice -= course.coursePrice;
  //       Get.snackbar("Shopping Cart", message!,
  //           duration: Duration(microseconds: 500));
  //     });
  //   }
  // }

  onSelectedRow(bool selected, DepartCourse course) async {
    String? message;
    if (selected) {
      //_addToCartList(course.courseId!, course.coursecode!, course.coursePrice);
      await _apiRepository
          .addToCart(course.courseId!, course.coursecode!, course.coursePrice)
          .then((value) {
        setState(() {
          message = value.toString();
        });
      });
      if (message != null) {
        setState(() {
          selectedCourses.add(course);
          _totalPrice += course.coursePrice;
        });
        Get.snackbar("Shopping Cart", message!,
            backgroundColor: Colors.white,
            colorText: Colors.purple,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.purple,
            ),
            duration: Duration(seconds: 3));
      }
    } else {
      // _deleteFromCartList(course.coursecode);
      await _apiRepository.deleteACourse(course.coursecode!).then((value) {
        setState(() {
          message = value.toString();
        });
      });
      if (message != null) {
        setState(() {
          selectedCourses.remove(course);
          _totalPrice -= course.coursePrice;
        });
      }
      Get.snackbar("Shopping Cart", message!,
          backgroundColor: Colors.white,
          colorText: Colors.purple,
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
          _totalPrice = 0;
        });
      }
    }
    Get.snackbar("Shopping Cart", message!,
        backgroundColor: Colors.white,
        colorText: Colors.purple,
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.purple,
        ),
        duration: Duration(seconds: 3));
    _loadDepartCourse();
  }

  // showIntroVideo(coursecode, description, url) async {
  //   var controller = _videoPlayerController;
  //   bool isInitialized = false;
  //   //url = extractPayload(url);
  //   print(url);
  //   final debunk = YoutubeExplode();
  //   final stream = await debunk.videos.streamsClient.getManifest(url);
  //   debunk.close();
  //   setState(() {
  //     controller = VideoPlayerController.network(
  //         stream.muxed.bestQuality.url.toString());
  //   });

  //   controller!.initialize().then((_) {
  //     setState(() {
  //       isInitialized = true;
  //     });
  //   });
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController!,
  //     autoPlay: true,
  //     looping: true,
  //     aspectRatio: 16 / 9,
  //     // overlay: DownloadButton(status: , progress: progress)
  //   );
  //   return showDialog(
  //       context: context,
  //       builder: (builder) {
  //         return AlertDialog(
  //           title: coursecode,
  //           content: isInitialized
  //               ? Column(
  //                   children: [
  //                     Chewie(controller: _chewieController!),
  //                     Text(description)
  //                   ],
  //                 )
  //               : Center(
  //                   child: CircularProgressIndicator(
  //                     color: Colors.purple,
  //                   ),
  //                 ),
  //         );
  //       });
  // }

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
                    //print("Onselect");
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
                          child: Text(course.coursePrice < 1
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new MaterialButton(
              child: Text(
                '₦' + "$_totalPrice",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(),
                  ),
                );
              },
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: _departCourse.isEmpty
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                      child: AnimatedDefaultTextStyle(
                    maxLines: 1,
                    child: Text(
                        "COURSE REGISTRATION PER SEMESTER OR PER 4 MONTHS INCASE OF STRIKE"),
                    style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                    duration: Duration(seconds: 10),
                  )),
                ),
                Expanded(
                  child: dataBody(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 1.0, top: 20.0, right: 5.0),
                      child: RaisedButton(
                        color: Colors.purple,
                        child: Text(
                          'CHECKOUT',
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
                      child: RaisedButton(
                        color: Colors.purple,
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

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }
}
