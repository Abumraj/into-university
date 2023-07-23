import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/screens/unihub.dart';
import '../dbHelper/db.dart';
import '../entities.dart';
import '../widgets/courseHeader.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<FirebaseLocalNotification> regCourse = [];
  bool isLoading = false;
  bool isFlutterLocalNotificationsInitialized = false;
  @override
  void initState() {
    super.initState();
    initInfo();
    loadRegCourse();
  }

  loadRegCourse() async {
    setState(() {
      isLoading = true;
    });
    final result = await ObjectBox.getAllNotification();
    setState(() {
      isLoading = false;
      regCourse = result;
    });
  }

  void initInfo() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var noteTime = message.sentTime!.toIso8601String();
      await ObjectBox.saveNotification(
        noteTime,
        message.data["dataTitle"],
        message.data["dataLink"],
        message.data["dataBody"],
        message.data["dataImageLink"],
      );
    });
    if (isFlutterLocalNotificationsInitialized) {
      return;
    } else {
      await FlutterNotificationChannel.registerNotificationChannel(
        description: 'This is AbumRaj channel',
        id: 'abumraj',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        name: 'abumraj',
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      isFlutterLocalNotificationsInitialized = true;
    }
  }

  Widget nView() {
    return Stack(
      children: [
        Container(
          height: 150,
          child: HeaderWidget1(150, true, "News"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : regCourse.isEmpty
              ? Center(
                  child: Text(
                    "No News yet",
                    style: TextStyle(color: Colors.purple, fontSize: 15),
                  ),
                )
              : ListView.builder(
                  itemCount: regCourse.length,
                  itemBuilder: (BuildContext context, int index) {
                    FirebaseLocalNotification reader = regCourse[index];
                    return ExpansionTile(
                      // isThreeLine: true,
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      trailing: Text(
                        timeago.format(DateTime.parse(reader.isLive.toString()),
                            allowFromNow: true),
                        style: TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                      title: Text(
                        reader.dataTitle.toString(),
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        reader.dataBody.toString(),
                        style: TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                      leading: Container(
                        width: 100,
                        height: 70,
                        child: CachedNetworkImage(
                          imageUrl: reader.dataImageLink!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: const CircularProgressIndicator(
                            color: Colors.purple,
                          )),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Image.asset("images/uniappLogo.png"),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: RichText(
                            text: TextSpan(
                              text: reader.dataBody.toString(),
                              style: context.textTheme.bodyText2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(Unihub(
                                customUrl: reader.dataLink,
                                news: "News",
                              ));
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    );
                  }),
    );
  }
}
