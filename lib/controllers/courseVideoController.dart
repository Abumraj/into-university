import 'package:get/get.dart';
import 'package:uniapp/models/videoCallModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class CourseVidseoController extends GetxController {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  CourseVidseoController() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    loadCourseVideo();
  }

  int counter = 0;
  RxList<CourseVideo> couseVideo = RxList();
  RxBool isLoading = false.obs;

  loadCourseVideo() async {
    showLoading();
    update();

    //print(isLoading);

    final result = await _apiRepository.getVideo();
    print("result $result");
    showLoading();
    update();
    print(isLoading);
    print(result.isNotEmpty);
    if (result.isNotEmpty) {
      couseVideo = result.obs;
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
