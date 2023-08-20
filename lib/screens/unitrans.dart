import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Services/uapi.dart';
import '../widgets/info.dart';

class UniTrans extends StatefulWidget {
  const UniTrans({Key? key}) : super(key: key);

  @override
  State<UniTrans> createState() => _UniTransState();
}

class _UniTransState extends State<UniTrans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UniRide"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      tutorsRequirements.logoBase64,
                      width: 50,
                      height: 80,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Join UniRide wait List",
                              style: context.textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "UniRide(Subsidiary of UniApp) ia a company which aims at not only easing the transportation of students on and off campus but also their inter-state movement.",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 6),
                      Text(
                        "With UniRide, students can order rides from the four corners of their hostels, get picked up and transported to their destinations (School and hostel/home) thereby reducing stress of fighting for buses (as the case in some universities), enabling them to mingle with fellow students and enjoy a swift and classy journey.",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 6),
                      Text(
                        "Our mission is also to provide employment opportunities to students and the public who can drive and posse neccessary driving documents",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "In adddition, we also provide business opportunity to the public (Students and non-students) who look forward to making profit from transportation business.",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "UniRide is coming soon. To recieve updates on UniRide, join our wait list by clicking on the suitable wait list button below. ",
                        style: context.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Uapi.joinTelegramGroupChat(
                                  "https://t.me/+3clsLeqMCfhlZjQ0", true);
                            },
                            child: const Text('Investors'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Uapi.joinTelegramGroupChat(
                                  "https://t.me/+Wyaix0952sQwOWU0", true);
                            },
                            child: const Text('Drivers'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Uapi.joinTelegramGroupChat(
                                  "https://t.me/+qBbSA_wdqy5lYWJk", true);
                            },
                            child: const Text('Students'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
