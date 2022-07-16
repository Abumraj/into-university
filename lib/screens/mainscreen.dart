import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/api.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/pages/aspiranVideo.dart';
import 'package:uniapp/pages/aspirantPdf.dart';
import 'package:uniapp/pages/news.dart';
import 'package:uniapp/screens/aboutUs.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/program.dart';
import 'package:uniapp/screens/refresh.dart';
import 'package:uniapp/screens/regcourse.dart';
import 'package:uniapp/screens/review.dart';

import '../Services/serviceImplementation.dart';

enum MenuItem {
  subscription,
  refresh,
  review,
  aboutUs,
  logOut,
  printing,
  project,
  vacation
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // late String userType;
  // late String token;
  @override
  void initState() {
    // _getUserTypeInState();
    super.initState();

    _tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
  }

  // _getUserTypeInState() async {
  //   await Constants.getUserTypeSharedPreference().then((value) {
  //     setState(() {
  //       userType = value.toString();
  //     });
  //   });
  //   await Constants.getUserTokenSharedPreference().then((value) {
  //     setState(() {
  //       token = value.toString();
  //     });
  //   });
  // }

  _logOut() {
    Api.logOUT(userType, token).then((value) {
      Constants.saveUserLoggedInSharedPreference(false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Programs()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
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
                case MenuItem.subscription:
                  userType == "stalite"
                      ? Get.to(StalHome())
                      : Get.to(PosSubHome());
                  break;
                case MenuItem.refresh:
                  Get.to(Refresh());
                  break;
                case MenuItem.review:
                  Get.to(Review());
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
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuItem.subscription,
                child: Text(
                  userType != "stalite" ? "Subscribe" : "Register",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.refresh,
                child: Text(
                  "Refresh Questions",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.review,
                child: Text(
                  "Write A Review",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.aboutUs,
                child: Text(
                  "About Us",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.logOut,
                child: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.printing,
                child: Text(
                  "Printing",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.project,
                child: Text(
                  "Project Writing",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: MenuItem.vacation,
                child: Text(
                  "Vacation Tour",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: <Widget>[
            Expanded(
              child: new Tab(
                text: "CBT",
              ),
            ),
            new Tab(icon: Icon(Icons.video_library)),
            new Tab(icon: Icon(Icons.radio_sharp)),
            new Tab(
              text: "Portal",
            )
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          Regcourse(),
          AspirantVideo(),
          AspirantPdf(),
          NewsReader()
        ],
      ),
    );
  }
}
