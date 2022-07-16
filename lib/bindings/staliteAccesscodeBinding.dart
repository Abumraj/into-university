import 'package:get/get.dart';
import 'package:uniapp/controllers/staliteAccessCodeController.dart';

class StaliteAccescodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaliteAccesscodeController());
  }
}
