import 'package:get/get.dart';
import 'package:uniapp/controllers/subscriptionAccesscodeController.dart';

class SubscriptionAccescodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubscriptionAccesscodeController());
  }
}
