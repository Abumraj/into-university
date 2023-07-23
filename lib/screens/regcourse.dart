import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/highscore.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/postUtme.dart';
import 'package:uniapp/widgets/courseHeader.dart';
import 'package:uniapp/widgets/hexColor.dart';
import 'package:uniapp/widgets/theme_helper.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../dbHelper/constant.dart';
import '../dbHelper/db.dart';
import '../entities.dart';

class Regcourse extends StatefulWidget {
  Regcourse({Key? key}) : super(key: key);

  @override
  State<Regcourse> createState() => _RegcourseState();
}

class _RegcourseState extends State<Regcourse> {
  List<RegCourse> regCourse = [];
  List<HighScore> highScore = [];
  bool isLoading = false;
  final ReceivePort _port = ReceivePort();
  int index = 0;
  String? userType;
  @override
  void initState() {
    loadRegCourse();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  loadRegCourse() async {
    setState(() {
      isLoading = true;
    });
    await Constants.getFirebaseTokenSharedPreference().then((value) {
      userType = value.toString();
    });
    final result = await ObjectBox.getAllRegCourse();
    setState(() {
      isLoading = false;
      regCourse = result;
    });
    if (DateTime.parse(result[0].expireAt!).isBefore(DateTime.now())) {
      await ObjectBox.truncateTable2();
      await ObjectBox.truncateTable3();
      await ObjectBox.truncateTable5();
      await ObjectBox.truncateTable6();

      List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
      for (var _task in getTasks!) {
        FlutterDownloader.remove(
          taskId: _task.taskId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : view(),
    ));
  }

  Widget view() {
    return Stack(children: <Widget>[
      Container(
        height: 150,
        child: HeaderWidget1(
            150, regCourse.isEmpty ? true : false, "My Registered Courses"),
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
                      userType == "semesterBased"
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
                    userType == "semesterBased"
                        ? Get.to(StalHome())
                        : Get.to(PosSubHome());
                  },
                ),
              ),
            )
          : Container(
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.9),
              itemBuilder: (BuildContext context, int index) {
                var courseVideo = regCourse[index];

                return SingleProt(
                  id: courseVideo.courseId!.toInt(),
                  code: courseVideo.coursecode.toString(),
                  description: courseVideo.courseDescrip.toString(),
                  expireAt: courseVideo.expireAt.toString(),
                  progress: courseVideo.progress!,
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
  final String expireAt;
  final int progress;

  SingleProt(
      {required this.id,
      required this.code,
      required this.description,
      required this.expireAt,
      required this.progress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: MaterialButton(
          padding: EdgeInsets.zero,
          height: 60,
          splashColor: Colors.purple,
          elevation: 2.0,
          onPressed: () {
            Get.to(PostUtme(coursecode: code, courseId: id));
          },
          onLongPress: () {
            Get.bottomSheet(
                CourseProgress(
                  coursecode: code,
                ),
                isScrollControlled: true,
                enterBottomSheetDuration: Duration(seconds: 2));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
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
                color: Colors.white,
              ),
              SizedBox(height: 8.0),
              Text(
                code,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
              SizedBox(height: 8.0),
              Text(
                description.toString(),
                style: TextStyle(
                    color: Colors.white,
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
              SizedBox(height: 8.0),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: LinearProgressIndicator(
                      color: Colors.green,
                      backgroundColor: Colors.white,
                      value: progress / 100,
                      semanticsLabel: "$progress%",
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Expires ${timeago.format(DateTime.parse(expireAt.toString()), allowFromNow: true)}",
                    style: TextStyle(color: Colors.red[400], fontSize: 12),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
