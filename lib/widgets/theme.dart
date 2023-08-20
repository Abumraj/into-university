import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
      primaryColor: Colors.purple,
      primarySwatch: Colors.purple,
      brightness: Brightness.light,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
}
