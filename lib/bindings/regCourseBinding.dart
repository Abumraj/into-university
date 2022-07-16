import 'package:get/get.dart';
import 'package:uniapp/controllers/regCourseController.dart';
import 'package:uniapp/dbHelper/db.dart';

class RegCourseBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DbHelper());
    Get.put(RegCourseController());
  }
}
