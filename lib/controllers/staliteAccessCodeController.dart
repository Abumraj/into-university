import 'package:get/get.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';
import 'package:uniapp/screens/paymentScreen.dart';

class StaliteAccesscodeController extends GetxController {
  ApiRepository _apiRepository = Get.find<ApiRepositoryImplementation>();

  StaliteAccesscodeController() {
    _apiRepository = Get.find<ApiRepositoryImplementation>();
    _getUserTypeIjjnState();
    _loadAcessCode();
  }
  final amount = CheckoutMethodBank().amount * 100;
  RxString accesscode = ''.obs;
  RxList<dynamic> verify = RxList();
  String email = '';
  RxBool isLoading = false.obs;

  _getUserTypeIjjnState() async {
    await Constants.getUserMailSharedPreference().then((value) {
      email = value.toString();
    });
  }

  _loadAcessCode() async {
    showLoading();

    final result = await _apiRepository.getStaAccessCode(amount, email);
    showLoading();
    if (result != null) {
      accesscode = result["data"]["authorization_url"].obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  _verifyTransaction(reference) async {
    showLoading();

    final result = await _apiRepository.verifyTransaction(reference);
    showLoading();
    if (result != null) {
      verify = result.obs;
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
