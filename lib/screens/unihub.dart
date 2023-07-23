import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/uapi.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home.dart';

class Unihub extends StatefulWidget {
  final String? customUrl;
  final String? news;
  Unihub({Key? key, this.customUrl, this.news}) : super(key: key);

  @override
  State<Unihub> createState() => _UnihubState();
}

int position = 1;
String website = 'https://unihub.ng/category/campus-foodie';
@override
void initState() {
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
}

class _UnihubState extends State<Unihub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1.0,
            title: widget.news == null
                ? Text("Less Stress, More Flex")
                : Text(widget.news!),
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
        body: IndexedStack(index: position, children: <Widget>[
          WebView(
            key: Key("8"),
            initialUrl: widget.customUrl == null ? website : widget.customUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://wa.me/')) {
                Uapi.joinTelegramGroupChat(request.url, true);
              }
              if (request.url.startsWith('https://twitter.com/')) {
                Uapi.joinTelegramGroupChat(request.url, true);
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (value) {
              setState(() {
                position = 1;
              });
            },
            onPageFinished: (value) {
              setState(() {
                position = 0;
              });
            },
            onWebResourceError: (error) {
              setState(() {
                position = 2;
              });
            },
          ),
          Container(
            child: Center(child: CircularProgressIndicator()),
          ),
          Container(
            child: Center(child: Text("An error occured")),
          ),
        ]));
  }
}
