import 'package:get/get.dart';
import 'package:uniapp/controllers/questionController.dart';

class ChapterBindings extends Bindings {
  @override
  void dependencies() {
    // Get.put(ChapterController());
    Get.put(QuestionController());
  }
}
