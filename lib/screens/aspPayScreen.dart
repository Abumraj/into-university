import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/screens/refresh.dart';
import 'package:uniapp/screens/unihub.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';

class AspCheckoutMethodBank extends StatefulWidget {
  final String? planCode;
  AspCheckoutMethodBank({this.planCode});
  @override
  _AspCheckoutMethodBankState createState() => _AspCheckoutMethodBankState();
}

class _AspCheckoutMethodBankState extends State<AspCheckoutMethodBank> {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  bool fetching = false;

  String reference = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Processing Payment",
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: IndexedStack(
          index: position,
          children: <Widget>[
            WebView(
              key: Key("1"),
              initialUrl: widget.planCode,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                print(request.url);
                if (request.url.startsWith('https://uniapp.ng/')) {
                  setState(() {
                    reference = request.url;
                  });
                  _apiRepository.getAccessCode(reference).then((value) {
                    Get.offAll(Refresh()); //close webview
                  });
                }
                if (request.url
                    .contains('https://standard.paystack.co/close')) {
                  _apiRepository.getAccessCode(reference).then((value) {
                    Get.offAll(Refresh()); //close webview
                  });
                }
                return NavigationDecision.prevent;
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
            )
          ],
        ));
  }
}
