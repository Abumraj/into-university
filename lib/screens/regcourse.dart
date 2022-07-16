import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/serviceImplementation.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/highscore.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/postUtme.dart';
import 'package:uniapp/widgets/courseHeader.dart';
import 'package:uniapp/widgets/hexColor.dart';
import 'package:uniapp/widgets/theme.dart';
import 'package:uniapp/widgets/theme_helper.dart';

import '../dbHelper/db.dart';
import '../models/highScoreModel.dart';
import '../models/regCourseModel.dart';

class Regcourse extends StatefulWidget {
  Regcourse({Key? key}) : super(key: key);

  @override
  State<Regcourse> createState() => _RegcourseState();
}

class _RegcourseState extends State<Regcourse> {
  // final regcourseController = Get.put(RegCourseController());
  DbHelper _dbHelper = DbHelper();
  List<RegCourse> regCourse = [];
  List<HighScore> highScore = [];
  bool isLoading = false;
  int index = 0;

  @override
  void initState() {
    loadRegCourse();
    super.initState();
  }

  loadRegCourse() async {
    setState(() {
      isLoading = true;
    });
    final result = await _dbHelper.getAllRegCourse();
    print("result $result");
    setState(() {
      isLoading = false;
      regCourse = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            )
          : view(),
    ));
  }

  Widget view() {
    return Stack(children: <Widget>[
      Container(
        height: 150,
        child: HeaderWidget1(150, true, "My Registered Courses"),
      ),
      regCourse.isEmpty
          ? Center(
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
                      userType == "stalite"
                          ? "Register".toUpperCase()
                          : "subscribe".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    userType == "stalite"
                        ? Get.to(StalHome())
                        : Get.to(PosSubHome());
                  },
                ),
              ),
            )
          : Container(
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemBuilder: (BuildContext context, int index) {
                var courseVideo = regCourse[index];

                return SingleProt(
                  id: courseVideo.courseId!.toInt(),
                  code: courseVideo.coursecode.toString(),
                  description: courseVideo.courseDescrip.toString(),
                );
              },
              itemCount: regCourse.length,
            )),
    ]);
  }
}

class SingleProt extends StatelessWidget {
  final int id;
  final String code;
  final String description;

  SingleProt({
    required this.id,
    required this.code,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          padding: EdgeInsets.zero,
          height: 60,
          elevation: 1.0,
          onPressed: () {
            Get.to(PostUtme(coursecode: code, courseId: id));
          },
          onLongPress: () {
            Get.bottomSheet(
              BottomSheet(
                backgroundColor: Colors.white,
                builder: (_) => CourseProgress(
                  coursecode: code,
                ),
                onClosing: () {},
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.grey.shade800,
          textColor: Colors.white70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.video_collection,
                size: 30,
                color: Colors.purple,
              ),
              SizedBox(height: 8.0),
              Text(
                code,
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
              SizedBox(height: 8.0),
              Text(
                description.toString(),
                style: TextStyle(
                    color: Colors.purple[500],
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 42.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );

    // ClipRRect(
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(10.0),
    //       ),
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //                 builder: (context) =>
    //                     VideoLists(courseId: id, coursecode: code)),
    //           );
    //         },
    //         child: Stack(
    //           children: <Widget>[
    //             Container(
    //               height: 150.0,
    //               width: 300.0,
    //               child: Image(
    //                 image: NetworkImage(imagePath),
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             Positioned(
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     gradient: LinearGradient(
    //                         begin: Alignment.bottomCenter,
    //                         end: Alignment.topCenter,
    //                         colors: [Colors.black, Colors.black12])),
    //               ),
    //             ),
    //             Positioned(
    //               left: 10.0,
    //               bottom: 10.0,
    //               right: 10.0,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         code,
    //                         style: TextStyle(
    //                             fontSize: 18.0,
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white),
    //                       ),

    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ));
  }

  // ListTile(
  //                 isThreeLine: true,
  //                 dense: true,
  //                 leading: Container(
  //                   width: 50,
  //                   height: 50,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       image: DecorationImage(
  //                           image: NetworkImage(
  //                               chapterList[index].chapterImage.toString()),
  //                           fit: BoxFit.fill)),
  //                 ),
  //                 title: Text(
  //                   chapterList[index].chapterName.toString(),
  //                   style: TextStyle(
  //                       color: Colors.purple,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 subtitle: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 8.0, right: 8.0, bottom: 8.0),
  //                   child: Text.rich(
  //                     TextSpan(
  //                         text: chapterList[index].chapterDescrip.toString()),
  //                     softWrap: true,
  //                     maxLines: 3,
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.purple[500],
  //                     ),
  //                   ),
  //                 ),
  //                 trailing: Badge(
  //                   toAnimate: true,
  //                   shape: BadgeShape.square,
  //                   badgeColor: Colors.white,
  //                   borderRadius: BorderRadius.circular(10),
  //                   badgeContent: Text(
  //                       "${chapterList[index].chapterVideoNum.toString()}",
  //                       style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.purple,
  //                           fontWeight: FontWeight.bold)),
  //                   child: Icon(
  //                     Icons.video_collection_sharp,
  //                     size: 30,
  //                     color: Colors.purple,
  //                   ),
  //                 ),
  //               ),

}
