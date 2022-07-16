import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color darkGrey = Color(0xFF121212);
const Color darkHeaderGrey = Color(0xFF424242);
const Color purple = Colors.purple;
late String isLightMode;

class Themes {
  // bool isLightMode = true;

  static final light = ThemeData(
      primaryColor: purple,
      brightness: Brightness.light,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));

  static final dark = ThemeData(
      primaryColor: darkGrey,
      brightness: Brightness.dark,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));

  // switchThemeMode() {
  //   Get.changeThemeMode(isLightMode ? ThemeMode.light : ThemeMode.dark);
  // }
}
