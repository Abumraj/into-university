import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// ignore: import_of_legacy_library_into_null_safe

class AspirantPdf extends StatefulWidget {
  @override
  _AspirantPdfState createState() => _AspirantPdfState();
}

class _AspirantPdfState extends State<AspirantPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple[500],
        child:
            WebviewScaffold(url: "https://www.youtube.com/watch?v=HPldXyxhyYA"),
      ),
    );
  }
}
