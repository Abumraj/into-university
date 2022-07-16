import 'package:get/get.dart';
import 'package:uniapp/controllers/courseVideoController.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class CourseVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiRepositoryImplementation());
    Get.put(CourseVidseoController());
  }
}
