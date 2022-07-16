import 'package:get/get.dart';
import 'package:uniapp/models/subModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class SubscriptionController extends GetxController {
  ApiRepository _apiRepository = Get.find<ApiRepositoryImplementation>();
  RxList<dynamic> subscriptions = RxList();
  RxBool isLoading = false.obs;
  SubscriptionController() {
    _apiRepository = Get.find<ApiRepositoryImplementation>();
    _subscriptionList();
  }

  _subscriptionList() async {
    showLoading();

    final result = await _apiRepository.getSubscription();
    showLoading();
    if (result != null) {
      subscriptions = result.obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  showLoading() {
    isLoading.toggle();
  }
}
