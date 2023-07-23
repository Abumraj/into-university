import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/uapi.dart';
import 'package:uniapp/widgets/info.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  myApp.logoBase64,
                  width: 30,
                  height: 70,
                ),
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          myApp.name,
                          style: context.textTheme.headline3,
                        ),
                        const Divider(height: 6),
                        Text(
                          myApp.description,
                          style: context.textTheme.bodyText2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "MISSION",
                          style: context.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myApp.mission,
                          style: context.textTheme.bodyText2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "VISSION",
                          style: context.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myApp.vision,
                          style: context.textTheme.bodyText2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Uapi.joinTelegramGroupChat(myApp.url, true);
                              },
                              child: const Text('Twitter'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Uapi.joinTelegramGroupChat(
                                    myApp.criteria, true);
                              },
                              child: const Text('Facebook'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Uapi.joinTelegramGroupChat(
                                    "https://www.instagram.com/p/CnMWsxhsKr9/?igshid=YmMyMTA2M2Y=",
                                    true);
                              },
                              child: const Text('Instagram'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text('Developer', style: context.textTheme.headline4),
                ),
                for (var ftinfo in developerInfos) ...[
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        ftinfo.logoBase64,
                        width: 80,
                        height: 100,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ftinfo.name,
                                style: context.textTheme.headline3,
                              ),
                              const Divider(height: 6),
                              Text(
                                ftinfo.description,
                                style: context.textTheme.bodyText2,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Uapi.joinTelegramGroupChat(ftinfo.url, true);
                                },
                                child: const Text('Follow on Twitter'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
