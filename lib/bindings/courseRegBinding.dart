import 'package:get/get.dart';
import 'package:uniapp/controllers/courseRegController.dart';

class CourseRegBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CourseRegController());
  }
}
