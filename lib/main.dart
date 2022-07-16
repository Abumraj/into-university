import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/bindings/CourseBinding.dart';
import 'package:uniapp/bindings/chapterBinding.dart';
import 'package:uniapp/bindings/chapterVideoListBinding.dart';
import 'package:uniapp/bindings/courseVideoBinding.dart';
import 'package:uniapp/bindings/regCourseBinding.dart';
import 'package:uniapp/pages/aspiranVideo.dart';
import 'package:uniapp/screens/aspPayScreen.dart';
import 'package:uniapp/screens/departmentSelecton.dart';
import 'package:uniapp/screens/mainscreen.dart';
import 'package:uniapp/screens/paymentScreen.dart';
import 'package:uniapp/screens/postSubscription.dart';
import 'package:uniapp/screens/postUtme.dart';
import 'package:uniapp/screens/regcourse.dart';
import 'package:uniapp/screens/signUp.dart';
import 'package:uniapp/screens/videoList.dart';
import 'package:uniapp/screens/welcome.dart';
import 'package:uniapp/widgets/theme.dart';
import 'Services/serviceImplementation.dart';
import 'bindings/facultyBinding.dart';
import 'bindings/staliteAccesscodeBinding.dart';
import 'bindings/subscriptionAccesscodeBinding.dart';
import 'bindings/subscriptionBinding.dart';
import 'dbHelper/constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//await di.init()
  runApp(Uniapp());
}

class Uniapp extends StatefulWidget {
  @override
  _UniappState createState() => _UniappState();
}

class _UniappState extends State<Uniapp> {
  bool isLightMode = true;
  bool isUserLoggedIn = false;
  // late FirebaseMessaging messaging;
  @override
  void initState() {
    getAuthCredentials();
    print("$isUserLoggedIn scores");
    super.initState();
  }

  Future getAuthCredentials() async {
    await Constants.getUerLoggedInSharedPreference().then((value) {
      isUserLoggedIn = value!;
    });
    await Constants.getUserTypeSharedPreference().then((value) {
      userType = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'UniApp', //title of app
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: isLightMode ? ThemeMode.light : ThemeMode.dark,
      getPages: [
        GetPage(name: "/home", page: () => MainScreen()),
        GetPage(name: "/Welcome", page: () => Welcome()),
        GetPage(
            name: "/Chapters",
            page: () => PostUtme(),
            binding: ChapterBindings()),
        GetPage(
            name: "/Chapter List",
            page: () => VideoLists(),
            binding: ChapterVideoListBinding()),

        GetPage(
            name: "/Faculty",
            page: () => StalHome(),
            binding: FacultyBinding()),
        GetPage(
            name: "/Subscription Plans",
            page: () => PosSubHome(),
            binding: SubscriptionBinding()),
        GetPage(
            name: "/Course Video",
            page: () => AspirantVideo(),
            binding: CourseVideoBinding()),
        GetPage(
          name: "/Sign Up",
          page: () => SignUp(),
        ),
        GetPage(
            name: "/Payment Screen",
            page: () => CheckoutMethodBank(),
            bindings: [StaliteAccescodeBinding(), CourseBinding()]),
        GetPage(
            name: "/Subscription Payment Screen",
            page: () => AspCheckoutMethodBank(),
            bindings: [SubscriptionAccescodeBinding(), CourseBinding()]),
        GetPage(
            name: "/My Courses",
            page: () => Regcourse(),
            binding: RegCourseBindings()),
        // GetPage(
        //   name: "/SplashScreen",
        //   page: () => SplashScreen(),
        // ),
      ],
      initialRoute: isUserLoggedIn == true ? "/home" : "/Welcome",
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 190,
//           ),
//           Center(
//             child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 65,
//                 child: Image.asset(
//                   "images/uniappLogo.png",
//                 )),
//           ),
//           SizedBox(
//             height: 242,
//           ),
//           Text(
//             "From",
//             style: TextStyle(
//                 fontSize: 10,
//                 letterSpacing: 2,
//                 fontWeight: FontWeight.normal,
//                 color: Colors.black),
//           ),
//           // SizedBox(
//           //   height: 15,
//           // ),
//           Expanded(
//             child: Text(
//               "AbumRaj",
//               style: TextStyle(
//                   fontSize: 23,
//                   letterSpacing: 1,
//                   fontWeight: FontWeight.normal,
//                   color: Colors.purple),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
