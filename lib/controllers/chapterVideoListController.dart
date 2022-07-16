import 'package:get/get.dart';
import 'package:uniapp/models/chapterVideoModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';
import 'package:uniapp/screens/videoList.dart';

class ChapterVideoListController extends GetxController {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());
  ChapterVideoListController() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    // _loadChapterList();
  }
  final int? courseId = VideoLists().courseId;
  int counter = 0;
  RxList<ChapterList> chapterList = RxList();
  RxBool isLoading = false.obs;

  // _loadChapterList() async {
  //   showLoading();

  //   final result = await _apiRepository.getChapterList(courseId!);
  //   showLoading();
  //   if (result.isNotEmpty) {
  //     chapterList = result.obs;
  //   } else {
  //     GetSnackBar(
  //       message: 'You have not Registered any course',
  //     );
  //   }
  // }

  // showLoading() {
  //   isLoading.toggle();
  // }
}
