import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/screens/refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';

class CheckoutMethodBank extends StatefulWidget {
  final amount;
  CheckoutMethodBank({this.amount});
  @override
  _CheckoutMethodBankState createState() => _CheckoutMethodBankState();
}

class _CheckoutMethodBankState extends State<CheckoutMethodBank> {
  bool isGeneratingCode = true;
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());
  int koboAmount = 0;
  bool fetching = false;
  String email = '';
  String authorisationUrl = '';
  String callbackUrl = '';
  String reference = '';
  int position = 1;
  @override
  void initState() {
    isGeneratingCode = true;
    koboAmount = widget.amount;
    _getUserTypeIjjnState();
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  _getUserTypeIjjnState() async {
    await Constants.getUserMailSharedPreference().then((value) {
      setState(() {
        email = value.toString();
      });
    });

    await _apiRepository.getStaAccessCode(koboAmount, email).then((value) {
      authorisationUrl = value["paystack"]["data"]["authorization_url"];
      callbackUrl = value["callback_url"];
      reference = value["paystack"]["data"]["reference"];
    });
    setState(() {
      isGeneratingCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            fetching ? "Fectching Resources" : "Processing Payment",
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: isGeneratingCode || fetching
            ? Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.purple,
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                    child: Text(
                      isGeneratingCode ? "Processing.." : "",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                ))
            : IndexedStack(index: position, children: <Widget>[
                WebView(
                  key: Key("3"),
                  initialUrl: authorisationUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  userAgent: "UniApp",
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
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url ==
                        'https://uniapp.ng/?trxref=$reference&reference=$reference') {
                      _apiRepository.verifyTransaction(reference).then((value) {
                        Get.offAll(Refresh()); //close webview
                      });
                    }
                    if (request.url
                        .startsWith('https://standard.paystack.co/close')) {
                      _apiRepository.verifyTransaction(reference).then((value) {
                        Get.offAll(Refresh()); //close webview
                      }); //close webview
                    }

                    return NavigationDecision.prevent;
                  },
                ),
                Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ]));
  }
}
