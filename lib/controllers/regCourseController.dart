import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/highScoreModel.dart';
import 'package:uniapp/models/regCourseModel.dart';

import '../screens/highscore.dart';

class RegCourseController extends GetxController {
  DbHelper _dbHelper = DbHelper();

  RegCourseController() {
    _dbHelper = Get.put(DbHelper());
    loadRegCourse();
  }

  RxList<RegCourse> regCourse = RxList();
  RxList<HighScore> highScore = RxList();
  RxBool isLoading = false.obs;

  loadRegCourse() async {
    showLoading();
    final result = await _dbHelper.getAllRegCourse();
    print("result $result");
    showLoading();
    update();
    print(isLoading);
    print(result.isNotEmpty);
    if (result.isNotEmpty) {
      regCourse = result.obs;
    } else {}
  }

  loadHighScore(String coursecode) async {
    final result = await _dbHelper.getAllHighScore(coursecode);
    print(result.isNotEmpty);
    if (result.isNotEmpty) {
      highScore = result.obs;
    } else {
      print("object");
      GetSnackBar(
        message: 'You have not started practising this course',
      );
      Get.bottomSheet(
        BottomSheet(
          backgroundColor: Colors.white,
          builder: (_) => CourseProgress(
            coursecode: coursecode,
          ),
          onClosing: () {},
        ),
      );
    }
  }

  showLoading() {
    isLoading.toggle();
  }
}
