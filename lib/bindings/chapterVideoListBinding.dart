import 'package:get/get.dart';
import 'package:uniapp/controllers/chapterVideoListController.dart';

class ChapterVideoListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChapterVideoListController());
  }
}
