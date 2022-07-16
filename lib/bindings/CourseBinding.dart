import 'package:get/get.dart';
import 'package:uniapp/controllers/courseController.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiRepositoryImplementation());
    Get.put(DbHelper());
    Get.put(CourseController());
  }
}
