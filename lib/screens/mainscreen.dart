import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/pages/aspiranVideo.dart';
import 'package:uniapp/pages/news.dart';
import 'package:uniapp/screens/aboutUs.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/notification.dart';
import 'package:uniapp/screens/phone.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/program.dart';
import 'package:uniapp/screens/refresh.dart';
import 'package:uniapp/screens/regcourse.dart';
import 'package:uniapp/widgets/gpapage.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';

enum MenuItem {
  subscription,
  unsubscribe,
  refresh,
  aboutUs,
  logOut,
  printing,
  project,
  vacation,
  gpcalculator,
  becomeAtutor
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userType;
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());
  final ReceivePort _port = ReceivePort();
  bool visible = false;
  // late String token;
  @override
  void initState() {
    _getUserTypeInState();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(downloadCallback);
    _tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
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

  _getUserTypeInState() async {
    await Constants.getFirebaseTokenSharedPreference().then((value) {
      setState(() {
        userType = value.toString();
      });
    });
  }

  _enableDisableSubscription() {
    String? message = "demo";
    _apiRepository.verifyTransaction("reference").then((value) {
      setState(() {
        message = value.toString();
      });
      if (message != null) {
        Get.snackbar("Status", "$message",
            titleText: Text(
              "Subscriiption Status",
              style: TextStyle(color: Colors.purple),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 5),
            messageText: Center(
              child: Text(
                "$message",
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ));
      }
    });
  }

  _logOut() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: new Text(
            "Log Out? You will lose all your Downloads",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 15.00,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: new Text("LogOut"),
              onPressed: () async {
                await deleteDbAndDownloads().then((_) {
                  Navigator.pop(context);
                });
              },
            ),
            SizedBox(
              width: 80,
            ),
            ElevatedButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteDbAndDownloads() async {
    setState(() {
      visible = true;
    });
    await _apiRepository.logOUT().then((value) async {
      if (value == "Logout successfully") {
        Constants.saveUserLoggedInSharedPreference(false);
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
        setState(() {
          visible = false;
          Get.offAll(Programs());
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 1,
        bottomOpacity: 1.0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "UniApp",
          style: TextStyle(
              color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (MenuItem value) {
              switch (value) {
                case MenuItem.aboutUs:
                  Get.to(AboutUs());
                  break;
                case MenuItem.unsubscribe:
                  _enableDisableSubscription();
                  break;
                case MenuItem.subscription:
                  userType == "semesterBased"
                      ? Get.to(StalHome())
                      : Get.to(PosSubHome());
                  break;
                case MenuItem.refresh:
                  Get.to(Refresh());
                  break;
                case MenuItem.logOut:
                  _logOut();
                  break;
                case MenuItem.printing:
                  break;
                case MenuItem.project:
                  break;
                case MenuItem.vacation:
                  break;
                case MenuItem.gpcalculator:
                  Get.to(GPA());
                  break;
                case MenuItem.becomeAtutor:
                  Get.to(PhoneSecurity());
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.subscription,
                child: Text(
                  userType != "semesterBased" ? "Subscribe" : "Register",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.refresh,
                child: Text(
                  "Refresh Questions",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.gpcalculator,
                child: Text(
                  "Gp Calculator",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                height: 15.0,
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.becomeAtutor,
                child: Text(
                  "Become A Tutor",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                height: 15.0,
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.printing,
                child: Text(
                  "Printing",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.project,
                child: Text(
                  "Project Writing",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.vacation,
                child: Text(
                  "Vacation Tour",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.aboutUs,
                child: Text(
                  "About Us",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                height: 15.0,
                value: MenuItem.logOut,
                child: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              if (userType != "semesterBased")
                PopupMenuItem(
                  value: MenuItem.unsubscribe,
                  child: Text(
                    "Enable/Disable Subscription",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  height: 15.0,
                ),
            ],
          )
        ],
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: <Widget>[
            new Tab(icon: Text("CBT")),
            new Tab(icon: Text("Video")),
            new Tab(icon: Text("NEWS")),
            new Tab(icon: Text("CHATS")),
          ],
        ),
      ),
      body: visible
          ? Visibility(
              visible: visible == true,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
              ),
            )
          : new TabBarView(
              controller: _tabController,
              children: <Widget>[
                Regcourse(),
                AspirantVideo(),
                Notifications(),
                NewsReader()
              ],
            ),
    );
  }
}
