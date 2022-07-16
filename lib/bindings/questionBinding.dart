import 'package:get/instance_manager.dart';
import 'package:uniapp/controllers/questionController.dart';

class QuestionBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionController());
  }
}
