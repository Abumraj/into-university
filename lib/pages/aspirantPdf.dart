import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe

class AspirantPdf extends StatefulWidget {
  @override
  _AspirantPdfState createState() => _AspirantPdfState();
}

class _AspirantPdfState extends State<AspirantPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: 100,
        child: Column(
          children: [
            Text("Trends from different campuses will show here",
                style: TextStyle(color: Colors.purple, fontSize: 16)),
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.speaker_group_outlined,
              size: 50,
              color: Colors.purple,
            )
          ],
        ),
      )),
    );
  }
}
