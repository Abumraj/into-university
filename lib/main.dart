import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/screens/home.dart';
import 'package:uniapp/screens/welcome.dart';
import 'package:uniapp/widgets/badCert.dart';
import 'package:uniapp/widgets/theme.dart';
import 'dbHelper/constant.dart';

@pragma('vm:entry-point')
late ObjectBox objectBox;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await ObjectBox.saveNotification(
    message.sentTime!.toIso8601String(),
    message.data["dataTitle"],
    message.data["dataLink"],
    message.data["dataBody"],
    message.data["dataImageLink"],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  bool? isLoggedIn = false;
  objectBox = await ObjectBox.create();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FlutterDownloader.initialize(debug: false);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  await Constants.getUerLoggedInSharedPreference().then((value) {
    isLoggedIn = value;
  });
  runApp(Uniapp(
    isLoggedIn: isLoggedIn,
  ));
}

class Uniapp extends StatefulWidget {
  final bool? isLoggedIn;

  const Uniapp({@required this.isLoggedIn});

  @override
  _UniappState createState() => _UniappState();
}

class _UniappState extends State<Uniapp> {
  bool isLightMode = true;
  bool? isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'UniApp',
      theme: Themes.light,
      onInit: () async {
        await Constants.getUerLoggedInSharedPreference().then((value) {
          isLoggedIn = value;
        });
      },
      getPages: [
        GetPage(name: "/home", page: () => Home()),
        GetPage(name: "/Welcome", page: () => Welcome()),
      ],
      initialRoute: widget.isLoggedIn == true ? "/home" : "/Welcome",
    );
  }
}
