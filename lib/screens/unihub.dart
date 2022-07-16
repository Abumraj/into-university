import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

import 'home.dart';

class Unihub extends StatefulWidget {
  Unihub({Key? key}) : super(key: key);

  @override
  State<Unihub> createState() => _UnihubState();
}

class _UnihubState extends State<Unihub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1.0,
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back_ios_new_sharp),
                  onPressed: () {
                    Get.offAll(() => Home());
                  },
                );
              },
            )),
        body: WebviewScaffold(
          url: "https://unihub.ng",
        ));
  }
}
