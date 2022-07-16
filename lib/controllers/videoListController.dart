import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/videoListModel.dart';
import 'package:uniapp/models/videoListModel.dart';

import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';
// import 'package:uniapp/widgets/videohome.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoListController extends GetxController {
  late ApiRepository _apiRepository;
  late DbHelper _dbHelper;
  late VideoPlayerController videoPlayerController;
  VideoListController() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    _dbHelper = Get.put(DbHelper());
    //_loadChapterList();
  }
  // ignore: unused_field

  List<VideoList> videoList = [];
  final int? chapterId = 1;

  RxBool isLoading = false.obs;
  RxBool isNoData = false.obs;

  // _loadChapterList() async {
  //   showLoading();

  //   final offResult = await _dbHelper.getSavedVideos(chapterId);
  //   final result = await _apiRepository.getVideoList(chapterId!);
  //   if (offResult.isEmpty && result.isNotEmpty) {
  //     videoList.addAll(result);
  //   } else if (offResult.isEmpty && result.isEmpty) {
  //     GetSnackBar(
  //       title: "Videos",
  //       message: "there are no videos for this chapter",
  //     );
  //   } else if (offResult.isNotEmpty && result.isEmpty) {
  //     videoList.addAll(offResult);
  //   } else {
  //     videoList.addAll(result);
  //     for (int i = 0; i < offResult.length; i++) {
  //       bool contain = videoList.contains(offResult[i].videoName);
  //       videoList.removeWhere((videoList) => contain == true);
  //     }
  //     videoList.addAll(offResult);
  //   }
  //   showLoading();

  //   // if (result!.isNotEmpty) {
  //   //   for (int i = 0; i < result.length; i++) {
  //   //     for (int j = 0; j < offResult.length; j++) {
  //   //       if (result[i].videoName == offResult[j].videoName) {
  //   //         result[i].videoUrl = offResult[j].videoUrl;
  //   //         result[i].thumbUrl = offResult[j].thumbUrl;
  //   //         result[i].status = offResult[j].status;
  //   //       }
  //   //     }

  //   //     videoList = result.obs;
  //   //   }
  //   // } else if (result.isNotEmpty && offResult.isEmpty) {
  //   //   videoList = result.obs;
  //   // } else if (result.isEmpty && offResult.isNotEmpty) {
  //   //   videoList = offResult.obs;
  //   // } else if (result.isEmpty && offResult.isEmpty) {
  //   //   hasData();
  //   // }
  // }

  // showLoading() {
  //   isLoading.toggle();
  // }

  // hasData() {
  //   isNoData.toggle();
  // }
}
