import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/notify.dart';
//import 'package:uniapp/models/notify.dart';

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  late final FirebaseMessaging _messaging;

  late int _totalNotificationCounter;
  Notifications? _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    // messaging.configure();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {}
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Notifications notification = Notifications(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data["title"],
          dataBody: message.data["body"],
          dataLink: message.data["link"]);
      setState(() {
        _totalNotificationCounter++;
        _notificationInfo = notification;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
