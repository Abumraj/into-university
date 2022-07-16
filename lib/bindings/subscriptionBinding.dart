import 'package:get/get.dart';
import 'package:uniapp/controllers/subscriptionController.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubscriptionController());
  }
}
