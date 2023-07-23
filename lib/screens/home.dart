import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/pages/aspirantPdf.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/mainscreen.dart';
import 'package:uniapp/screens/phone.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/unihub.dart';
import 'package:uniapp/screens/unitrans.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  List<Widget> screens = [
    MainScreen(),
    StalHome(),
    PosSubHome(),
    AspirantPdf(),
    UniTrans(),
    PhoneSecurity()
  ];
  String? userType;
  @override
  void initState() {
    _getUserTypeInState();
    super.initState();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentPage = MainScreen();
  _getUserTypeInState() async {
    await Constants.getFirebaseTokenSharedPreference().then((value) {
      setState(() {
        userType = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentPage),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        heroTag: null,
        child: CircleAvatar(
          child: Image.asset("images/uniappLogo.png"),
          backgroundColor: Colors.white,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentPage = MainScreen();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: currentTab == 0
                                ? Colors.purpleAccent
                                : Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        userType == "semesterBased"
                            ? Get.to(StalHome())
                            : Get.to(PosSubHome());
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: currentTab == 1
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                        Text(
                          userType == "semesterBased"
                              ? "Register"
                              : "Subscribe",
                          style: TextStyle(
                            color: currentTab == 1
                                ? Colors.purpleAccent
                                : Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      Get.to(Unihub());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: currentTab == 2
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                        Text(
                          "UniHub",
                          style: TextStyle(
                            color: currentTab == 2
                                ? Colors.purpleAccent
                                : Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentPage = UniTrans();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.taxi_alert_sharp,
                          color: currentTab == 3
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                        Text(
                          "UniRide",
                          style: TextStyle(
                            color: currentTab == 3
                                ? Colors.purpleAccent
                                : Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
