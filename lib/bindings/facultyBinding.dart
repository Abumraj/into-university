import 'package:get/get.dart';
import 'package:uniapp/controllers/facultyController.dart';

class FacultyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FacultyController());
  }
}
