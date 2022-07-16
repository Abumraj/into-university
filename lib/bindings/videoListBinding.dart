import 'package:get/instance_manager.dart';
import 'package:uniapp/controllers/videoListController.dart';

class PideoListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoListController());
  }
}
